# name: discourse-ai-unescape
# about: Fixes escaped markdown quotes (\u003e) in posts
# version: 1.0
# authors: JesusBYS
# url: https://github.com/JesusBYS/discourse-ai-unescape

after_initialize do
  def fix_markdown_quotes(post)
    return if post.blank? || post.raw.blank?

    raw = post.raw

    # Corrige \u003e et \\u003e
    fixed = raw.gsub(/\\\\u003e|\\u003e/, ">")

    return if fixed == raw

    post.update_columns(raw: fixed)
    post.rebake!
  end

  DiscourseEvent.on(:post_created) { |post, *_| fix_markdown_quotes(post) }
  DiscourseEvent.on(:post_edited)  { |post, *_| fix_markdown_quotes(post) }
end
