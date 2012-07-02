data Note = Note
    { noteDate    :: Data.Time.Day
    , noteAuthor  :: Maybe Data.Text.Text
    , noteContent :: Yesod.Form.Fields.Textarea
    }
  deriving Show
