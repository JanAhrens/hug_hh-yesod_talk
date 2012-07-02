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
