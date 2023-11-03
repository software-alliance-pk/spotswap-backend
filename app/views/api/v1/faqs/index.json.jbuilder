json.faqs @faqs do |faq|
  json.partial! 'shared/faq_details', faq: faq
end