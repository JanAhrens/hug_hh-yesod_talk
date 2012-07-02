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
