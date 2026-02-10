# name: discourse-ai-unescape
# about: Unescapes \u003e \u003c \u0026 in AI/bot posts so Markdown stays clean
# version: 0.1
# authors: You
# url: https://github.com/<YOU>/discourse-ai-unescape

enabled_site_setting :ai_unescape_enabled

after_initialize do
  DiscourseEvent.on(:post_created) do |post, _opts, _user|
    next if !SiteSetting.ai_unescape_enabled
    next if post.blank? || post.raw.blank?
    next if post.user.blank?

    # Ne touche que les comptes bot (ex: gpt4_bot, claude_bot, etc.)
    next unless post.user.bot?

    raw = post.raw

    # Discourse/JSON escaping typique
    fixed = raw
      .gsub('\\u003e', '>')
      .gsub('\\u003c', '<')
      .gsub('\\u0026', '&')

    next if fixed == raw

    post.raw = fixed
    post.save!(validate: false)

    # Rebake pour que cooked reflète le raw corrigé
    post.rebake!
  end
end
