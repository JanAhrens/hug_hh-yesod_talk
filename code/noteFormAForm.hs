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
