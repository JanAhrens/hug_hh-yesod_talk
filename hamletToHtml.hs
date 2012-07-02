{-# LANGUAGE QuasiQuotes, TemplateHaskell, OverloadedStrings #-}

import qualified Data.Text
import qualified Data.Text.IO
import qualified Data.Text.Lazy.IO as L

import Text.Hamlet (hamletFile)
import Text.Blaze (preEscapedToMarkup)
import Text.Blaze.Html.Renderer.Text (renderHtml)

readCodeSnippet name = do
  content <- Data.Text.IO.readFile ("code/" ++ name)
  return $ Data.Text.stripEnd content

main = do
     helloWorld  <- readCodeSnippet "helloWorld.hs"
     hamletDemo <- readCodeSnippet "hamletDemo.hamlet"
     helloWithoutTH <- readCodeSnippet "helloWithoutTH.hs"
     cassiusDemo <- readCodeSnippet "cassiusDemo.css"
     luciusDemo <- readCodeSnippet "luciusDemo.css"
     juliusDemo <- readCodeSnippet "juliusDemo.js"
     noteFormData <- readCodeSnippet "noteFormData.hs"
     noteFormAForm <- readCodeSnippet "noteFormAForm.hs"
     noteFormValue <- readCodeSnippet "noteFormValue.hs"
     noteFormRender <- readCodeSnippet "noteFormRender.hs"
     noteFormRenderResult <- readCodeSnippet "noteFormRenderResult.html"
     noteFormProcess <- readCodeSnippet "noteFormProcess.hs"
     noteFormWithMForm <- readCodeSnippet "noteFormWithMForm.hs"
     renderDivsSignature <- readCodeSnippet "renderDivsSignature.hs"
     L.putStrLn $ renderHtml ($(hamletFile "index.hamlet") undefined)
