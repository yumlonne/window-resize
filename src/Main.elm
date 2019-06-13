port module Main exposing (main)

import Browser
import Time

import Browser.Events
import Element exposing (..)
import Element.Input as Input
import Element.Background as Background
import Element.Border as Boader
import Element.Font as Font
import Html exposing (Html)



-- MAIN


main =
    Browser.document
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { resizeWidth : Bool
    , resizeHeight : Bool
    , width : Int
    , height : Int
    , velocity : Float
    , sinAnimationValue : Float
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { resizeWidth = False
      , resizeHeight = False
      , width = initWidth
      , height = initHeight
      , velocity = 1.0
      , sinAnimationValue = 0.0
      }
    , Cmd.none
    )

initWidth = 500
initHeight = 500

-- UPDATE


type Msg
    = OnClickWidthCheckbox Bool
    | OnClickHeightCheckbox Bool
    | OnChangeVelocity Float
    | UpdateWindowSize
    | OnClickPopupButton


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnClickWidthCheckbox check ->
            ( { model | resizeWidth = check }
            , Cmd.none
            )

        OnClickHeightCheckbox check ->
            ( { model | resizeHeight = check }
            , Cmd.none
            )

        OnChangeVelocity velocity ->
            ( { model | velocity = velocity }
            , Cmd.none
            )

        UpdateWindowSize ->
            let
                -- 標準は2秒でループ
                sinAnimationValue =
                    model.sinAnimationValue + (pi / 60) * model.velocity

                width =
                    if model.resizeWidth then
                        initWidth + calcSideSizeOffset sinAnimationValue
                    else
                        model.width

                height =
                    if model.resizeHeight then
                        initHeight + calcSideSizeOffset sinAnimationValue
                    else
                        model.height
            in
            ( { model
                | width = width
                , height = height
                , sinAnimationValue = sinAnimationValue
              }
            , resizeWindow ( model.width, model.height )
            )

        OnClickPopupButton ->
            ( model
            , popup ()
            )


calcSideSizeOffset : Float -> Int
calcSideSizeOffset sinAnimationValue =
    round <| 200 * sin sinAnimationValue



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Time.every 30 <|
        always UpdateWindowSize



-- COMMAND


port resizeWindow : ( Int, Int ) -> Cmd msg
port popup : () -> Cmd msg


-- VIEW


view : Model -> Browser.Document Msg
view model =
    { title = "resize window"
    , body = body model
    }


body : Model -> List (Html Msg)
body model =
    List.singleton <|
        layout [] <|
            column [ width fill, height fill, spacing 14]
                [ Input.checkbox [ centerX, width <| px 70 ]
                    { onChange = OnClickWidthCheckbox
                    , icon = Input.defaultCheckbox
                    , checked = model.resizeWidth
                    , label = Input.labelRight [ centerX ] <| text "よこ"
                    }
                , Input.checkbox [ centerX, width <| px 70 ]
                    { onChange = OnClickHeightCheckbox
                    , icon = Input.defaultCheckbox
                    , checked = model.resizeHeight
                    , label = Input.labelRight [ centerX ] <| text "たて"
                    }
                , el [ centerX ] <| Input.slider [ width <| px 150 ]
                    { onChange = OnChangeVelocity
                    , label = Input.labelBelow [ centerX ] <| text "←速さ→"
                    , min = 0.5
                    , max = 1.5
                    , value = model.velocity
                    , thumb = Input.defaultThumb
                    , step = Just 0.1
                    }
                , Input.button [ centerX, width <| px 150, height <| px 75, Background.color <| rgb255 180 70 180 ]
                    { onPress = Just OnClickPopupButton
                    , label = el [ centerX, centerY, Font.color <| rgb 0 0 0 ] (text "popup!")
                    }
                , el [ centerX, Font.color <| rgb255 230 40 40 ] <|
                    text "※PCでフルスクリーンじゃないブラウザから押してね!"
                ]
