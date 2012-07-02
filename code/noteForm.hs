{-# LANGUAGE TemplateHaskell, QuasiQuotes, OverloadedStrings,
             MultiParamTypeClasses, TypeFamilies #-}
import Yesod
import qualified Yesod.Form.Fields
import Yesod.Form.Jquery
import Data.Text (Text)
import Control.Applicative ((<$>), (<*>))
import qualified Data.Time
import qualified Data.Text

data HelloForm = HelloForm

instance Yesod HelloForm
instance YesodJquery HelloForm

mkYesod "HelloForm" [parseRoutes|
/     RootR GET
/note NoteR POST
|]

data Note = Note
    { noteDate    :: Data.Time.Day
    , noteAuthor  :: Maybe Data.Text.Text
    , noteContent :: Yesod.Form.Fields.Textarea
    }
  deriving Show

instance RenderMessage HelloForm FormMessage where
  renderMessage _ _ = defaultFormMessage

noteForm :: Html
         -> MForm HelloForm HelloForm (FormResult Note, Widget)
noteForm = renderDivs $
  Note <$> areq (jqueryDayField def)       "Date"   Nothing
       <*> aopt textField                  "Author" Nothing
       <*> areq (checkTextareaLength 1 10) "Note"   Nothing
  where
    checkTextareaLength lower upper
      = check (checkLength lower upper) textareaField

    checkLength :: Int -> Int -> Textarea
                -> Either Text Textarea
    checkLength l u ta | taLen ta >= l &&
                         taLen ta <= u = Right ta
                       | otherwise     = Left "Note too long"

    taLen ta = Data.Text.length . unTextarea $ ta

noteForm' :: Html
          -> MForm HelloForm HelloForm (FormResult Note, Widget)
noteForm' extra = do
  (dateRes, dateView) <- mreq (jqueryDayField def) "" Nothing
  (authorRes, authorView) <- mopt textField "" Nothing
  (contentRes, contentView) <- mreq (checkTextareaLength 1 10) "" Nothing

  let noteRes = Note <$> dateRes <*> authorRes <*> contentRes

  let widget = do
      toWidget [lucius|
        ##{fvId dateView} {
          width: 3em;
        }
      |]

      [whamlet|
        #{extra}
        <p>
          On ^{fvInput dateView}, ^{fvInput authorView} write:
        <p>
          ^{fvInput contentView}
      |]

  return (noteRes, widget)

  where
    checkTextareaLength lower upper
      = check (checkLength lower upper) textareaField

    checkLength :: Int -> Int -> Textarea
                -> Either Text Textarea
    checkLength l u ta | taLen ta >= l &&
                         taLen ta <= u = Right ta
                       | otherwise     = Left "Note too long"

    taLen ta = Data.Text.length . unTextarea $ ta

getRootR :: Handler RepHtml
getRootR = do
  (formFields, enctype) <- generateFormPost noteForm
  renderForm formFields enctype

  where
    renderForm fields enctype = defaultLayout [whamlet|
      <form method=POST action=@{NoteR} enctype=#{enctype}>
        ^{fields}
          <input type=submit>
    |]

postNoteR :: Handler RepHtml
postNoteR = do
  ((result, formFields), enctype) <- runFormPost noteForm

  case result of
    FormSuccess note -> do
                          setMessage "Note created"
                          redirect RootR
    FormMissing      -> renderForm formFields enctype
    FormFailure _    -> renderForm formFields enctype

  where
    renderForm fields enctype = defaultLayout [whamlet|
      <form method=POST action=@{NoteR} enctype=#{enctype}>
        ^{fields}
        <input type=submit>
    |]

main :: IO ()
main = warpDebug 3000 HelloForm
