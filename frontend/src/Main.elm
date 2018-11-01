port module Main exposing (Flags, Model, Msg(..), init, main, onUrlChange, pushUrl, subscriptions, update, view)

import Api.Object exposing (Patient)
import Api.Object.Patient as Patient
import Api.Query as Query
import Api.Scalar
import Browser
import Element
import Graphql.Http
import Graphql.Operation
import Graphql.SelectionSet exposing (SelectionSet, with)
import Html exposing (Html)
import Http


main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- Model


type alias Model =
    { status : Status }


type Status
    = Loading
    | Loaded Response
    | Failed (Graphql.Http.Error Response)


type alias Response =
    { patientResponse : Maybe PatientResponse }


type alias PatientResponse =
    { firstName : Maybe String
    , lastName : Maybe String
    }



-- Init


type alias Flags =
    { locationHref : String
    }


init : Flags -> ( Model, Cmd Msg )
init flags =
    ( { status = Loading
      }
    , getPatient
    )



-- View


view : Model -> Html Msg
view model =
    Element.layout [] <|
        case model.status of
            Loading ->
                Element.text "Loading..."

            Loaded response ->
                case response.patientResponse of
                    Nothing ->
                        Element.text "Patient not found."

                    Just patient ->
                        Element.column []
                            [ Element.text "Patient loaded!"
                            , Element.text <| "First name: " ++ (patient.firstName |> Maybe.withDefault "???")
                            , Element.text <| "Last name: " ++ (patient.lastName |> Maybe.withDefault "???")
                            ]

            Failed responseErrorHttpGraphql ->
                Element.text <| graphqlErrorToString responseErrorHttpGraphql



-- Update


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged String
    | PatientLoaded (Result (Graphql.Http.Error Response) Response)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            ( model, Cmd.none )

        UrlChanged url ->
            ( model, Cmd.none )

        PatientLoaded (Ok patient) ->
            ( { model | status = Loaded patient }
            , Cmd.none
            )

        PatientLoaded (Err error) ->
            ( { model | status = Failed error }
            , Cmd.none
            )


getPatient : Cmd Msg
getPatient =
    queryPatient
        |> Graphql.Http.queryRequest "http://localhost:5000/graphql"
        |> Graphql.Http.send PatientLoaded


queryPatient : Graphql.SelectionSet.SelectionSet Response Graphql.Operation.RootQuery
queryPatient =
    Query.selection Response
        |> with (Query.patientById { id = Api.Scalar.BigInt "1" } patientSelection)


patientSelection : SelectionSet PatientResponse Api.Object.Patient
patientSelection =
    Patient.selection PatientResponse
        |> with Patient.firstName
        |> with Patient.lastName


graphqlErrorToString : Graphql.Http.Error Response -> String
graphqlErrorToString error =
    case error of
        Graphql.Http.GraphqlError possiblyParsedData graphqlError ->
            "GraphqlError"

        Graphql.Http.HttpError httpError ->
            httpErrorToString httpError


httpErrorToString : Http.Error -> String
httpErrorToString error =
    case error of
        Http.BadUrl errorMessage ->
            errorMessage

        Http.Timeout ->
            "Request timed out."

        Http.NetworkError ->
            "Request failed to send. Is your Internet working?"

        Http.BadStatus response ->
            response.status.message

        Http.BadPayload errorMessage response ->
            errorMessage



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    onUrlChange UrlChanged



-- NAVIGATION


port onUrlChange : (String -> msg) -> Sub msg


port pushUrl : String -> Cmd msg
