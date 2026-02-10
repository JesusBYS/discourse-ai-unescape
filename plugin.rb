# name: discourse-ai-unescape
# about: Unescapes \u003e in bot posts so Markdown quotes stay clean
# version: 0.1
# authors: You
# url: https://github.com/<YOU>/discourse-ai-unescape

enabled_site_setting :ai_unescape_enabled

after_initialize do
  DiscourseEvent.on(:post_created) do |post, _opts, _user|
    next unless SiteSetting.ai_unescape_enabled
    next if post.blank? || post.raw.blank? || post.user.blank?
    next unless post.user.bot?

    raw = post.raw
    fixed = raw.gsub('\\u003e', '>')

    next if fixed == raw

    post.update_columns(raw: fixed)
    post.rebake!
  end
end
