import consumer from "./consumer"

let chat_id = ''
$(document).on('turbolinks:load', function(){
    chat_id = $("#chatmessagebox").attr('data-id');
});
$(document).ready(function(){
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
            $('#submitaddphoto').val('');
            $('#submitaddfile').val('');
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

                        '<div class="img mt-4">' +
                        (data.message_file !== '' ? "<iframe src=" + data.message_file + "></iframe>" + '</div>' +
                        '<button type="button" class="btn down_btn">' +
                        '<img src="/assets/icon-arrow-bottom.svg" alt="">' +
                        '</button>' +
                        '</div>' : "") +
                        '</p>' +
                        '</div>' +
                        '<p>' + time_ago(data.created_at) + '</p>' +
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
                        '</div>' + '<p>' + time_ago(data.created_at) + '</p>' +
                        '</div>');
                }
                $(".msg_contain").scrollTop($(".msg_contain")[0].scrollHeight);
                $("#input_field_text").val('');

            }
        }
    });

});

function time_ago(time) {
    switch (typeof time) {
      case 'number':
        break;
      case 'string':
        time = +new Date(time);
        break;
      case 'object':
        if (time.constructor === Date) time = time.getTime();
        break;
      default:
        time = +new Date();
    }
    var time_formats = [
      [60, 'seconds', 1], // 60
      [120, '1 minute ago', '1 minute from now'], // 60*2
      [3600, 'minutes', 60], // 60*60, 60
      [7200, '1 hour ago', '1 hour from now'], // 60*60*2
      [86400, 'hours', 3600], // 60*60*24, 60*60
      [172800, 'Yesterday', 'Tomorrow'], // 60*60*24*2
      [604800, 'days', 86400], // 60*60*24*7, 60*60*24
      [1209600, 'Last week', 'Next week'], // 60*60*24*7*4*2
      [2419200, 'weeks', 604800], // 60*60*24*7*4, 60*60*24*7
      [4838400, 'Last month', 'Next month'], // 60*60*24*7*4*2
      [29030400, 'months', 2419200], // 60*60*24*7*4*12, 60*60*24*7*4
      [58060800, 'Last year', 'Next year'], // 60*60*24*7*4*12*2
      [2903040000, 'years', 29030400], // 60*60*24*7*4*12*100, 60*60*24*7*4*12
      [5806080000, 'Last century', 'Next century'], // 60*60*24*7*4*12*100*2
      [58060800000, 'centuries', 2903040000] // 60*60*24*7*4*12*100*20, 60*60*24*7*4*12*100
    ];
    var seconds = (+new Date() - time) / 1000,
      token = 'ago',
      list_choice = 1;
  
    if (seconds == 0) {
      return 'Just now'
    }
    if (seconds < 0) {
      seconds = Math.abs(seconds);
      token = 'from now';
      list_choice = 2;
    }
    var i = 0,
      format;
    while (format = time_formats[i++])
      if (seconds < format[0]) {
        if (typeof format[2] == 'string')
          return format[list_choice];
        else
          return Math.floor(seconds / format[2]) + ' ' + format[1] + ' ' + token;
      }
    return time;
  }
