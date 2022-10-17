car_brand = CarBrand.create(title: "Tesla")
1.upto(4) do |index|
  car_brand.car_models.create(title: "Model #{index}")
end
car_brand = CarBrand.create(title: "Toyota")
1.upto(4) do |index|
  car_brand.car_models.create(title: "Model #{index}")
end
car_brand = CarBrand.create(title: "Hyundai")
1.upto(4) do |index|
  car_brand.car_models.create(title: "Model #{index}")
end
car_brand = CarBrand.create(title: "Isuzu")
1.upto(4) do |index|
  car_brand.car_models.create(title: "Model #{index}")
end

Page.destroy_all
Page.create(title: "Terms & Conditions", permalink: "terms&condition",content: "<h3> General Terms </h3>
  <p> By accessing and placing an order with UI Design, you confirm that you are in agreement with and bound by the terms and conditions contained in the Terms Of Use outlined below. These terms apply to the entire website and any email or other type of communication between you and UI Design.</p>
  <h3> Templates </h3>
  <p>All products and services are delivered by UI Design electronically to your email address. UI Design is not responsible for any technological delays beyond our control. If your spam blocker blocks our emails from reaching you or you do not provide a valid email address where you can be reachable then you can access your download from the Profile page.</p>
  <h3> Licensing & Usage </h3>
  <p>The use of an item is bound by the license you purchase. A license grants you a non-exclusive and non-transferable right to use and incorporate the template in your personal or commercial projects. There are two licenses available: Regular and Extended.</p>
  <h3> Regular License: Single Application License </h3>
  <p>Your use of the item is restricted to a single installation.
  The item may not be redistributed or resold.
  If the item contains licensed components, those components must only be used within the item and you must not extract and use them on a stand-alone basis.
  If the item was created using materials which are the subject of a GNU General Public License (GPL), your use of the item is subject to the terms of the GPL in place of the foregoing conditions (to the extent the GPL applies).
  Extended License: Multiple Applications License
  Your use of the item may extend to multiple installations.
  The item may not be redistributed or resold.
  If the item contains licensed components, those components must only be used within the item and you must not extract and use them on a stand-alone basis.
  If the item was created using materials which are the subject of a GNU General Public License (GPL), your use of the item is subject to the terms of the GPL in place of the foregoing conditions (to the extent the GPL applies).
  You are responsible to choose the appropriate license type. You are not allowed to redistribute these files in any way.</p>
  <h3> Security </h3>
  <p>UI Design does not process any order payments through the website. All payments are processed securely through PayPal, a third party online payment provider.</p>
  <h3> Refunds </h3>
  <p>You have 24 hours to inspect your purchase and to determine if it does not meet with the expectations. In the event that you wish to receive a refund, UI Design will issue you a refund and ask you to specify how the product failed to live up to expectations.</p>
  <h3> Support </h3>
  <p>UI Design offers these templates and designs ‘as is’, with no implied meaning that they will function exactly as you wish or with all 3rd party components and plugins. Further, we offer no support via email or otherwise for installation, customization, administration of the templates on the operating system itself. We do, however offer support for errors and bugs pertaining to the templates. We are also happy to walk customers through the template structure and answer any support queries in that regard.</p>
  <h3> Ownership </h3>
  <p>You may not claim intellectual or exclusive ownership to any of our products, modified or unmodified. All products are property of UI Design. Our products are provided “as is” without warranty of any kind, either expressed or implied. In no event shall our juridical person be liable for any damages including, but not limited to, direct, indirect, special, incidental or consequential damages or other losses arising out of the use of or inability to use our products.</p>
  <h3> Price Changes </h3>
  <p>UI Design reserves the right at any time and from time to time to modify or discontinue, temporarily or permanently, a subscription (or any part thereof) with or without notice. Prices of all subscriptions and products, including but not limited to monthly subscription plan fees, are subject to change upon 30 days notice from us. Such notice may be provided at any time by posting the changes to the UI Design website.</p>
  <h3> Warranty </h3>
  <p>UI Design does not warranty or guarantee these templates in any manner. We cannot guarantee they will function with all 3rd party components, plugins or operating systems. Compatibility should be tested against the demonstration templates on the demo operating system simulators. Please ensure that the operating systems you use will work with the templates as we can not guarantee that UI Design templates will work with all operating systems. Our company reserves the right to change or modify current Terms and Conditions with no prior notice.</p>")
Page.create(title: "Privacy Policy", permalink: "privacy_policy",content: "<p>The following terminology applies to these Terms and Conditions, Privacy Statement and Disclaimer Notice and all Agreements: <q>Client</q>, <q>You</q> and <q>Your</q> refers to you, the person log on this website and compliant to the Company’s terms and conditions. <q>The Company</q>, <q>Ourselves</q>, <q>We</q>, <q>Our</q> and <q>Us</q>, refers to our Company. <q>Party</q>, <q>Parties</q>, or <q>Us</q>, refers to both the Client and ourselves. All terms refer to the offer, acceptance and consideration of payment necessary to undertake the process of our assistance to the Client in the most appropriate manner for the express purpose of meeting the Client’s needs in respect of provision of the Company’s stated services, in accordance with and subject to, prevailing law of Netherlands. Any use of the above terminology or other words in the singular, plural, capitalization and/or he/she or they, are taken as interchangeable and therefore as referring to same.</p>")
Page.create(title: "FAQ", permalink: "faq",content: "<p> The following organizations may link to our Website without prior written approval: </p> <ul> <li>Government agencies;</li> <li>Search engines;</li> <li>News organizations;</li> <li>Online directory distributors may link to our Website in the same manner as they hyperlink to the Websites of other listed businesses; and System wide Accredited Businesses except soliciting non-profit organizations, charity shopping malls, and charity fundraising groups which may not hyperlink to our Web site. </li> </ul> </n> <p> These organizations may link to our home page, to publications or to other Website information so long as the link: (a) is not in any way deceptive; (b) does not falsely imply sponsorship, endorsement or approval of the linking party and its products and/or services; and (c) fits within the context of the linking party’s site. </p> </n> <p> We may consider and approve other link requests from the following types of organizations: </p>")



