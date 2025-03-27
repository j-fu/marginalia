### A Pluto.jl notebook ###
# v0.20.5

using Markdown
using InteractiveUtils

# ╔═╡ 60941eaa-1aea-11eb-1277-97b991548781
begin 
	using Pkg
	Pkg.activate(joinpath(@__DIR__,".."))
	using Revise
	using PlutoUI
	using {PKGNAME}
end

# ╔═╡ 5b7da564-8c8e-45c9-8c72-534c5a13301d
md"""
# Demo notebook for {PKGNAME}
"""

# ╔═╡ 882dda23-63b9-4b1e-a04e-69071deff69a
md"""
This notebook is only relocateable together with the whole {PKGNAME} project.
All packages used by this notebook need to be added to the environment in 
$(dirname(joinpath(@__DIR__,".."))).
"""

# ╔═╡ a8e37976-5db2-485f-87aa-0cf7155e8e00
{PKGNAME}.greet()

# ╔═╡ Cell order:
# ╟─5b7da564-8c8e-45c9-8c72-534c5a13301d
# ╟─882dda23-63b9-4b1e-a04e-69071deff69a
# ╠═60941eaa-1aea-11eb-1277-97b991548781
# ╠═a8e37976-5db2-485f-87aa-0cf7155e8e00
