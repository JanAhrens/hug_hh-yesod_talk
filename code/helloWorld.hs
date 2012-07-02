{-# LANGUAGE TemplateHaskell, QuasiQuotes,
             MultiParamTypeClasses, TypeFamilies #-}
import Yesod

data HelloWorld = HelloWorld

instance Yesod HelloWorld

mkYesod "HelloWorld" [parseRoutes|
/ HomeR GET
|]

getHomeR :: Handler RepHtml
getHomeR = defaultLayout [whamlet|Hello World!|]

main :: IO ()
main = warpDebug 3000 HelloWorld
