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
