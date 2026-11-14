module AdminHelper
  def admin_nav_link(label, path)
    active = path == admin_root_path ? current_page?(path) : request.path.start_with?(path)
    link_to label, path,
            class: "inline-flex min-h-11 items-center whitespace-nowrap rounded-t-lg px-3 " \
                   "#{active ? 'bg-slate-100 text-brand-blue' : 'text-white/90 hover:text-white'}"
  end
end
