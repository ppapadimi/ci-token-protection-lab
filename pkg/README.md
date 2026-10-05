# pkg

Stand-in for a package directory that exists in the checkout. The privileged consumer
extracts the untrusted archive into `pkg/.static_bundle`, i.e. inside the checked-out
workspace, which is what the replicated pattern does.
