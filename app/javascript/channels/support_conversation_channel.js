import consumer from "./consumer"

let chat_id = ''
$(document).on('turbolinks:load', function(){
    chat_id = $("#chatmessagebox").attr('data-id');
});
$(document).on('turbolinks:load', function(){
    chat_id = $("#chatmessagebox").attr('data-id');
    const email = $("#admin_email").data("admin");
    console.log(chat_id);
    consumer.subscriptions.create({channel: "SupportConversationChannel", id: "support_conversation_" + chat_id}, {
        connected() {
            console.log("Connected SupportConversation Channel")
            // Called when the subscription is ready for use on the server
        },

        disconnected() {
            // Called when the subscription has been terminated by the server
        },

        received(data) {
            if (data.support_conversation_id == chat_id) {
                if (data.user_id == null) {
                    $(".msg_contain").append('<div class="msg admin">' +
                        '<div class="profile">' +
                        (data.sender_image !== '' ? "<img src=" + data.sender_image + ">" : "<img src='/assets/default-profile.jpg'>") +
                        '</div>' +
                        '<div class="msg_wrapper">' +
                        '<div class="msg_blk">' +
                        '<p>' + data.body +
                        '<div class="attch_blk">' +
                        '<div class="img">' +
                        (data.message_image !== '' ? "<img src=" + data.message_image + ">" + '</div>' +
                        '<button type="button" class="btn down_btn">' +
                        '<img src="/assets/icon-arrow-bottom.svg" alt="">' +
                        '</button>' +
                        '</div>' : "") +
                        '</p>' +
                        '</div>' +
                        '<p>' + data.created_at + '</p>' +
                        '</div>' +
                        '</div>');

                } else {
                    $(".msg_contain").append('<div class="msg user">' +
                        '<div class="profile">' +
                        (data.sender_image !== '' ? "<img src=" + data.sender_image + ">" : "<img src='/assets/default-profile.jpg'>") +
                        '</div>' +
                        '<div class="msg_wrapper">' +
                        '<div class="msg_blk">' +
                        '<p>Open a Support Ticket <strong>' +
                        data.ticket_number.ticket_number +
                        '</strong></p>' +
                        '<p>' + data.body + '</p>' +
                        '<div class="attch_blk">' +
                        (data.message_image !== '' ? '<div class="img">' + "<img src=" + data.message_image + ">" + '</div>'  +
                        '<button type="button" class="btn down_btn">' +'<img src="/assets/icon-arrow-bottom.svg">' + '</button>'
                        +'</div>' : '')
                         +
                        '</div>' + '<p>' + data.created_at + '</p>' +
                        '</div>');
                }
                $(".msg_contain").scrollTop($(".msg_contain")[0].scrollHeight);
                $("#input_field_text").val('');

            }
        }
    });

});
