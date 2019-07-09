
module RestLinkProcsHelpers
  def link_procs(**options)
    options.reverse_merge! verify_path: false

    Templet::Links::RestLinkProcs.new(nil, **options)
  end

  def execute(link_proc, model, parent, **opts)
    link = link_proc.(renderer, model, parent)

    return link, link[1]
  end
end

