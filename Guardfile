guard :shell do
  watch('index.hamlet') { `make` }
  watch(%r{\Acode/.*}) { `make` }
end
