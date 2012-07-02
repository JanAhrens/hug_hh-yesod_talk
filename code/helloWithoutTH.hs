{-# LANGUAGE MultiParamTypeClasses, TypeFamilies #-}
import Yesod
import Yesod.Routes.Dispatch (toDispatch, Route(..))
import Text.Blaze.Internal (preEscapedText)
import Data.Text (pack)
import Data.Map (fromList, lookup)

data HelloWorld = HelloWorld

instance Yesod HelloWorld

instance RenderRoute HelloWorld where
  data Route HelloWorld = HomeR deriving (Show, Eq, Read)
  renderRoute HomeR = ([], [])

type Handler = GHandler HelloWorld HelloWorld
type Widget  = GWidget  HelloWorld HelloWorld ()

instance YesodDispatch HelloWorld HelloWorld where
  yesodDispatch master sub toMaster app404 handler405
                method pieces
    = case dispatch pieces of
        Just f  -> f master sub toMaster app404
                     handler405 method
        Nothing -> app404
    where
      dispatch = toDispatch [Route [] False onHome]
      onHome [] =
        Just $ \ master sub toMaster _ _handler405 _method ->
          case Data.Map.lookup _method methodsHomeR of
            Just f  -> yesodRunner f master sub
                                   (Just HomeR) toMaster
            Nothing -> _handler405 HomeR
      methodsHomeR = fromList [(pack "GET", fmap chooseRep
                                                 getHomeR)]

getHomeR :: Handler RepHtml
getHomeR = defaultLayout
  (toWidget . preEscapedText . pack $ "Hello World!")

main :: IO ()
main = warpDebug 3000 HelloWorld
