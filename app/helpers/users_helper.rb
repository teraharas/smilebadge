module UsersHelper
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
  
  def get_graph(user_id, bumon_id, type)
      # グラフインスタンス取得
      
      badgejoin = Badge.arel_table
      badgepostjoin = Badgepost.arel_table
      
      join_condition = badgejoin.join(badgepostjoin, Arel::Nodes::OuterJoin)
                .on(badgejoin[:id].eq(badgepostjoin[:badge_id])).join_sources
      
      if type == "30DAYS_RECEPT"
        if bumon_id == ""
          @badgeposts = Badge.joins(join_condition).group(:id, :name, :image, :outputnumber)
              .select(badgejoin[:id], badgejoin[:name], badgejoin[:image], badgejoin[:outputnumber], badgejoin[:id].count.as('cnt'))
                    .where(badgepostjoin[:recept_user_id].eq(user_id))
                    .where(badgepostjoin[:created_at].gt 30.days.ago)
                    .order('cnt DESC').order(badgejoin[:id])
        else
          taisyou_users = User.where(bumon_id: bumon_id)
          taisyou_user_ids = Array.new
          taisyou_users.each do |user|
            taisyou_user_ids.push(user.id)
          end
          @badgeposts = Badge.joins(join_condition).group(:id, :name, :image, :outputnumber)
              .select(badgejoin[:id], badgejoin[:name], badgejoin[:image], badgejoin[:outputnumber], badgejoin[:id].count.as('cnt'))
                    .where(badgepostjoin[:recept_user_id].in(taisyou_user_ids))
                    .where(badgepostjoin[:created_at].gt 30.days.ago)
                    .order('cnt DESC').order(badgejoin[:id])
          # binding.pry
        end
      elsif type == "ALL_RECEPT"
        @badgeposts = Badge.joins(join_condition).group(:id, :name, :image, :outputnumber)
              .select(badgejoin[:id], badgejoin[:name], badgejoin[:image], badgejoin[:outputnumber], badgejoin[:id].count.as('cnt'))
                    .where(badgepostjoin[:recept_user_id].eq(user_id))
                    .order('cnt DESC').order(badgejoin[:id])
      else
        @badgeposts = Badge.joins(join_condition).group(:id, :name, :image, :outputnumber)
              .select(badgejoin[:id], badgejoin[:name], badgejoin[:image], badgejoin[:outputnumber], badgejoin[:id].count.as('cnt'))
                    .where(badgepostjoin[:sent_user_id].eq(user_id))
                    .order('cnt DESC').order(badgejoin[:id])
      end
  
      data = Array.new
      
      @badgeposts.each do |badgepost|
        data.push([badgepost.name, badgepost.cnt])
      end
      
      @graph = LazyHighCharts::HighChart.new('graph') do |f|
        # グラフタイトル
        if type == "30DAYS_RECEPT"
          if bumon_id == ""
            f.title(text: '30日間に獲得したバッジバランス')
          else
            f.title(text: Bumon.find(bumon_id).name + "が30日間に獲得したバッジバランス")
          end
        elsif type == "ALL_RECEPT"
          f.title(text: '今までに獲得したバッジバランス')
        else
          f.title(text: '今までに贈ったバッジバランス')
        end
        f.series(name: 'バッジ数', data: data, type: 'pie')
      end
  end
end