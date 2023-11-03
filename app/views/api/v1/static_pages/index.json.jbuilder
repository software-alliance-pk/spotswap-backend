json.page do
  json.title @page.title
  json.permalink @page.permalink
  json.content @page.content.body.to_trix_html
end