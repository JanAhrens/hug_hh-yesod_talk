type FormRender sub master a =
       AForm sub master a
    -> Markup
    -> MForm sub master (FormResult a, Widget)
