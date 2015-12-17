function set_badge_id(badge_id, usablebadgecount) {
    // バッジ送付可能数0以下ならチェックONにしない
    // if (usablebadgecount <= 0) {
    //     exit;
    // }
    // バッジIDを隠し項目に退避する
    $(':hidden[name="badgepost[badge_id]"]').val(badge_id);
    // チェックマークの表示非表示
    $(".badge_checked").hide();
    $("#badge_checked_" + badge_id).show();
}