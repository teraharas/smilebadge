function set_badge_id(badge_id, badge_name) {
  // バッジIDを隠し項目に退避する
  $(':hidden[name="badgepost[badge_id]"]').val(badge_id);
  // チェックマークの表示非表示
  $(".badge_checked").hide();
  $("#badge_checked_" + badge_id).show();
  
  // バッジの小刻みな回転アクションの追加
  $(".largebadgeimage").css('animation', '')
  $("#id_badgelargeimage_" + badge_id).css('animation', 'shake 0.5s infinite linear')
  $("#id_badgelargeimage_" + badge_id).css('animation-iteration-count', 'infinite')
  $("#id_badgelargeimage_" + badge_id).css('animation-duration', '10s')
  $(".largebadgeimage").css('-webkit-animation', '')
  $("#id_badgelargeimage_" + badge_id).css('-webkit-animation', 'shake 0.5s infinite linear')
  $("#id_badgelargeimage_" + badge_id).css('-webkit-animation-iteration-count', 'infinite')
  $("#id_badgelargeimage_" + badge_id).css('-webkit-animation-duration', '10s')

  document.getElementById("selected_badge_name").innerText = badge_name + "バッジを選択中！";
}
