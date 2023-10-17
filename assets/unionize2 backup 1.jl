### A Pluto.jl notebook ###
# v0.19.12

using Markdown
using InteractiveUtils

# ╔═╡ 60941eaa-1aea-11eb-1277-97b991548781
begin 
    using PlutoUI
	using BenchmarkTools
end

# ╔═╡ 0898ac67-775a-49db-ad2a-e72f84aaaea3
md"""
# Unionize your collections!

J. Fuhrmann
- v0.3, 2022-09-08: Updated with Julia 1.8
- v0.2, 2022-02-09: increased union size to 10, made code a bit more elegant
- v0.1, 2022-02-08: started with union size 5
"""

# ╔═╡ d49a26dd-c503-44aa-982a-ad3dedbec613
md"""
When working e.g with agent based models or finite elements with varying element geometries, a common pattern is the occurence of collections of objects of different types on which one wants to perform certain actions depending on their type.

We can observe at least three patterns related to this type of situation:

- __Collection of objects:__ This is e.g. a vector of instantations of structs of different types, and the most intuitive way of using this pattern. Calling methods of some function on a member of this collection leads to [dynamic dispatch](https://discourse.julialang.org/t/dynamic-dispatch/6963/2), which has certain runtime costs due to necessary allocations.
- __Collection of types:__  Julia allows to use types as variables. These can be stored  in a collection as well, and it is possible to  dispatch on the type. No need to have an instantiation of the type. One also can work with abstract types here.
- __Collection of functions:__ Instead of objects or types, one also can store functions in a collection. Accessing a function as a member of a collection once again will lead to dynamic dispatch.

[Union splitting](https://julialang.org/blog/2018/08/union-splitting/) allows to avoid dynamic dispatch and can save significant runtime costs. Below, we try to explain, how this can be used.

"""

# ╔═╡ 14d0ec92-43ff-4cc6-9510-b2e84beb104d
md"""
Set the size of example collections:
"""

# ╔═╡ 4bfe6bc8-3c08-443f-bc8e-c6c2ee415ef1
N=100;

# ╔═╡ 1f2c9fe9-7076-40d1-b049-0be760180a1b
md"""
## Collection of objects
"""

# ╔═╡ ba62da3e-723b-4595-b423-ae371f0c01d8
md"""
Let us define ten different structs which we well use as mock incarnations of e.g. agent models:
"""

# ╔═╡ 4bddcabb-fc8b-4c3f-9d05-db4838ec65e9
begin 
	struct S01 end
	struct S02 end
	struct S03 end
	struct S04 end
	struct S05 end
	struct S06 end
	struct S07 end
	struct S08 end
	struct S09 end
	struct S10 end
end

# ╔═╡ 75d97586-8ac2-48f2-bdad-790a93f2df3b
allS=(S01,S02,S03,S04,S05,S06,S07,S08,S09,S10)

# ╔═╡ c97d9b7b-27fd-4a62-ba10-1946ee2964cc
md"""
Define a function with a method for each of these types:
"""

# ╔═╡ 41ff535c-cdb6-499b-818b-49b32e6c77c4
begin
    f(::S01,x)=1x
    f(::S02,x)=2x
    f(::S03,x)=3x
    f(::S04,x)=4x
    f(::S05,x)=5x
    f(::S06,x)=6x
    f(::S07,x)=7x
    f(::S08,x)=8x
    f(::S09,x)=9x
    f(::S10,x)=10x
end

# ╔═╡ 7a9399ff-7684-4f63-8b04-e3b3bb250e37
md"""
Now, we create vector of different agents.
"""

# ╔═╡ 3c7cff9b-c3f2-484b-a4c3-1fb2fa682be1
any_collection=[rand(allS)() for i=1:N]

# ╔═╡ b76b2a71-97ef-4db6-a64b-ebd3b5d6f1e6
md"""
As no further information is available, the type of this collection is `Vector{Any}`:
"""

# ╔═╡ 7f36b41d-a591-44fc-b80f-cf4731d45574
typeof(any_collection)

# ╔═╡ 6b319342-b0a7-4ef4-a81e-828a8bfd76f8
md"""
### Dynamic dispatch
"""

# ╔═╡ ac9a80bc-1c65-4c7f-a550-3465c7d2039a
md"""
Define some action - just sum up the results of `f` acting on the members:
"""

# ╔═╡ 79c3b7bb-28b4-40c6-be93-386a43134996
md"""
As the benchmark shows, each access of an element is linked to an allocation:
"""

# ╔═╡ fda0443c-0165-496f-a77a-551c98e811cb
md"""
The use of `sum` reduces the amount of allocations, runtime becomes a bit shorter:
"""

# ╔═╡ e0021adb-6878-467a-b015-02170d0031b6
md"""
Julia has to detect at runtime, wich of the methods of `f` to call.
"""

# ╔═╡ af8e6eec-e9f5-4777-bbc1-3f50786cf544
md"""
### Manual dispatch
"""

# ╔═╡ fa17546c-225e-4732-9c81-0e25ccd6f507
md"""
An alternative is _manual dispatch_
"""

# ╔═╡ a2f17607-fd3a-4e92-ba4f-75d0e09e7bbf
md"""
In this code, each time when c is accessed as a function parameter, due to the test via `isa`, the compiler knows the type of `c` and can choose the proper methof of `f` at compile time. As we see, this avoids the allocations connected with dynamic dispatch and the corresponding runtime overhead.
"""

# ╔═╡ 03e23cec-0f66-45a1-8b29-2779607f3a00
md"""
### Union splitting
"""

# ╔═╡ 5e217b3e-ab9a-437a-a7bf-fca8dc604e4e
md"""
While it is possible to generate the manual dispatch code with macros, another remedy of this situation appears to be more acessible.
"""

# ╔═╡ c41ac605-2d45-4730-a2aa-df66136d98a8
md"""
Define a union type, and essentially the same collection, but with this union type instead of `Any` as element type:
"""

# ╔═╡ 68946d74-63f3-44fa-b267-54d830ad00ef
const UnionS=Union{allS...}

# ╔═╡ f8432585-1d5e-41e5-87dd-0f099f770b5c
unionS_collection=UnionS[o for o ∈ any_collection]

# ╔═╡ 64ebb6a5-a9af-4b9e-8f8c-1a3010c9bd7e
typeof(unionS_collection)

# ╔═╡ 05a7038f-f033-426d-9abc-d065ec8c4fa3
md"""
Due to union splitting, the compiler knows that the number of possible types of the elements of the collection is finite -- constrained by the list of types in the union.
Consequently, it can create code similar to the manual dispatch statement above.
"""

# ╔═╡ 0208f08a-6475-4e96-991d-a12d1eda624f
md"""
(Remark: with `c ∈ collection` in `sumup_f` there is currently no performance gain)
"""

# ╔═╡ 958ca00a-4ad9-4de8-a147-2d5942ff0ad6
md"""
## Collection of types
"""

# ╔═╡ c5fdf045-d6f8-4074-aeba-5bb5469bb5ba
md"""
The same pattern can be applied to e.g. vectors of data types.
"""

# ╔═╡ a45bca8e-72d6-4853-b995-1372e12e4813
datatype_collection=rand(allS,N)

# ╔═╡ c32ecb40-cecf-4c36-9c8c-0432e1cbb67a
typeof(datatype_collection)

# ╔═╡ c270cbcd-a71e-409c-aabf-79ba59aaa156
md"""
### Dynamic dispatch
"""

# ╔═╡ 02908d24-6efd-4c48-97f2-893431876942
md"""
In this case, we need to dispatch on the parametric type `Type{}`; 
"""

# ╔═╡ 801dee68-b7be-4d9a-a0da-d46e8817d9e8
begin
    f(::Type{S01},x)=1x
    f(::Type{S02},x)=2x
    f(::Type{S03},x)=3x
    f(::Type{S04},x)=4x
    f(::Type{S05},x)=5x
    f(::Type{S06},x)=6x
    f(::Type{S07},x)=7x
    f(::Type{S08},x)=8x
    f(::Type{S09},x)=9x
    f(::Type{S10},x)=10x
end

# ╔═╡ cc87f4cb-94c1-4607-9fe7-0d551d0f5b4c
function sumup_f(collection)
	s=0
	for i ∈ eachindex(collection)
		s+=f(collection[i],1)
	end
	s
end

# ╔═╡ 61dabfa0-e296-4624-afda-a529510a1003
@benchmark sumup_f(any_collection)

# ╔═╡ 22bb9b5f-6e99-402c-9b83-6b210b9a3bd5
@benchmark sumup_f(unionS_collection)

# ╔═╡ 21a0ed5b-d2ac-4859-832b-a1fc75dd8e3e
@benchmark sum(x->f(x,1),any_collection)

# ╔═╡ 2a6e0171-529f-4ce3-b2a9-8f73fdf8b71e
function sumup_f_manual(collection)
	s=0.0
	for c ∈ collection
		if isa(c,S01)
			s+=f(c,1)
		elseif isa(c,S02)
			s+=f(c,1)
		elseif isa(c,S03)
			s+=f(c,1)
		elseif isa(c,S04)
			s+=f(c,1)
		elseif isa(c,S05)
			s+=f(c,1)
		elseif isa(c,S06)
			s+=f(c,1)
		elseif isa(c,S07)
			s+=f(c,1)
		elseif isa(c,S08)
			s+=f(c,1)
		elseif isa(c,S09)
			s+=f(c,1)
		elseif isa(c,S10)
			s+=f(c,1)
		end
	end
	s
end

# ╔═╡ fd4d0549-c6a2-427b-97d8-96c63d26eb24
@benchmark sumup_f_manual(any_collection)

# ╔═╡ d63ae4aa-2de5-4836-b755-7a055d250e4e
@benchmark sum(x->f(x,1),unionS_collection)

# ╔═╡ f58cdb62-e1fc-4ed8-ad12-1c74ee4ce353
md"""
However, accessing the parametric type is once again connected with the dynamic dispatch overhead:
"""

# ╔═╡ 54951111-57a8-4aa8-bc5f-b4b7cbaec33b
@benchmark sumup_f(datatype_collection)

# ╔═╡ 67af2890-dbc5-4eee-ab2e-cc72074481c8
@benchmark sum(x->f(x,1),datatype_collection)

# ╔═╡ a899b8b1-4782-404b-ba4b-da6c4debb31e
md"""
### Union splitting
"""

# ╔═╡ b70ee55e-b91a-4420-bf95-8d41b6b78bbc
md"""
Manual dispatch is straightforward to implement here as well, so we focus on union splitting and define the following union of parametric types and a collection with this union as elemenent type.
"""

# ╔═╡ c02e8832-9586-4dff-9a5c-bb318ed44bc3
const UnionTS=Union{[Type{s} for s in allS]...}

# ╔═╡ 751c89ee-5d2c-4132-bd20-f4522235f35a
unionTS_collection=UnionTS[o for o ∈ datatype_collection]

# ╔═╡ 75e34a9f-60f2-40ad-a193-71cd9eeb5a0b
typeof(unionTS_collection)

# ╔═╡ 10c5a294-5e21-4d2b-aee8-c180cb06e0d9
md"""
As we see again, the dynamic dispatch overhead goes away:
"""

# ╔═╡ e885889a-4766-4390-a3b5-63db1e56b5a4
@benchmark sumup_f(unionTS_collection)

# ╔═╡ f8670360-3d3b-4593-b1f2-ee0f8f75f711
@benchmark sum(x->f(x,1),unionTS_collection)

# ╔═╡ 5988d3ed-b370-4b7e-8698-f9bbcb376bc9
md"""
## Collection of Abstract Types
"""

# ╔═╡ ab28bcc8-f4fb-47b4-8ee6-41948bad0abe
begin 
	abstract type T01 end
	abstract type T02 end
	abstract type T03 end
	abstract type T04 end
	abstract type T05 end
	abstract type T06 end
	abstract type T07 end
	abstract type T08 end
	abstract type T09 end
	abstract type T10 end
end

# ╔═╡ ed4c2dc0-f3a9-42fe-8c2c-8fae10585f19
allT=(T01,T02,T03,T04,T05,T06,T07,T08,T09,T10)

# ╔═╡ 92e9756f-30aa-4c2b-8ff2-3c4d832e94f0
md"""
## Collection of functions

Instead of working with different methods triggered by the object stored in the collection, sometimes storing different functions in a collection is a useful pattern as well.
"""

# ╔═╡ 53712b18-5c51-4e50-b137-b7cfac43bc35
begin
    f01(x)=1x
    f02(x)=2x
    f03(x)=3x
    f04(x)=4x
    f05(x)=5x
    f06(x)=6x
    f07(x)=7x
    f08(x)=8x
    f09(x)=9x
    f10(x)=10x 
end

# ╔═╡ 1d7a3b43-b9b2-4d60-a7a6-2689967fe473
allf=(f01,f02,f03,f04,f05,f06,f07,f08,f09,f10)

# ╔═╡ 066ccd3e-018c-4f78-a77d-f3bcf2711834
function sumup_funcs(collection)
	s=0.0
	for i ∈ eachindex(collection)
		s+=collection[i](1)
	end
	s
end

# ╔═╡ dafc4860-d2b9-4940-bf66-cbcd11592027
func_collection=rand(allf,N)

# ╔═╡ db65bcd3-44f6-4557-bab9-0c14826123ba
md"""
In Julia, each function has its own type, which is a subtype of `Function`, which therefore is an abstract type:
"""

# ╔═╡ c48c7899-ee26-45a3-80d6-3e08e3522964
typeof(f01)==typeof(f02)

# ╔═╡ 509cf0ca-7eb1-42f2-bf00-ffb9702a373a
isa(f02,Function)

# ╔═╡ 57b4a9d1-94e6-47dd-bb60-e106f546a125
isconcretetype(Function)

# ╔═╡ 5229fe37-6228-4e85-a503-a8355f7694a2
typeof(func_collection)

# ╔═╡ 2aa2c229-0471-4c9b-8f69-1f63f7753d42
md"""
### Dynamic dispatch
"""

# ╔═╡ 7760fc0e-cf94-4fac-a553-ff6061a2e612
md"""
As a consequence, accessing a function from the collection once again is connected with dynamic dispatch overhead and an allocation:
"""

# ╔═╡ 78408644-96ca-426f-b2d5-0bb683cd0e8f
@benchmark sumup_funcs(func_collection)

# ╔═╡ 0b29f85b-bdf0-426a-8bc5-4946b4d89f87
@benchmark sum( f->f(1),func_collection)

# ╔═╡ ebb273d6-1e6d-4e3d-95b1-300b59ababec
md"""
### Union splitting
"""

# ╔═╡ ae2712cf-6a80-467e-8f99-7786e1f87c0a
md"""
We can define a union of the possible function types and thus constrain the number of possible function types occuring during the element access:
"""

# ╔═╡ 39794bef-d215-4d7d-ba1a-35953d9049c4
const UnionF=Union{[typeof(f) for f in allf]...}

# ╔═╡ f0709de9-a3e1-4c2d-8d6e-5d5b66917337
unionF_collection=UnionF[f for f ∈ func_collection]

# ╔═╡ 7eee7597-1d4f-4df5-afb2-a4d1d3afe9e5
typeof(unionF_collection)

# ╔═╡ 2d6ec664-7203-47ba-a749-76a3c947acf4
md"""
Union splitting works here as well, we see the allocations vanish.
"""

# ╔═╡ f1a94bfa-911d-4641-8ffb-8761d687f10c
@benchmark sumup_funcs(unionF_collection)

# ╔═╡ 4a4ee1f7-0e46-4ab9-a7ef-cbab5be7592f
@benchmark sum( f->f(1),unionF_collection)

# ╔═╡ 5ceeff92-9ff7-4515-ba60-fc0909c5233a
md"""
## Discussion
"""

# ╔═╡ da54e050-43b8-4683-8374-58004a23a7f5
md"""
As shown above, union splitting is a highly useful and relatively easy to use concept to avoid dynamic dispatch overhead. 

It appears that [Tim Holy](https://github.com/timholy) [introduced](https://julialang.org/blog/2018/08/union-splitting/)  this concept to the broader community with Julia 0.7 in  2018.

At that time, union splitting was limited to "small" unions. Up to now, the [manual]("https://docs.julialang.org/en/v1/manual/types/#footnote-1) says: " "Small" is defined by the `MAX_UNION_SPLITTING` constant, which is currently set to 4." 

I think I have first noticed this pattern in a Discourse thread on [avoiding vectors of abstract types](https://discourse.julialang.org/t/avoiding-vectors-of-abstract-types/61883/8).

However it seems  that with  [#37378](https://github.com/JuliaLang/julia/pull/37378)  the "small union" constraint of union splitting is gone, which kind of has been confirmed [here](https://discourse.julialang.org/t/union-splitting-vs-c/61772/16).

In fact, the same tests as above can be performed with much larger unions, which has not been done in this notebook for convenience, and it appears that this pattern can be applied safely on many occasions.

However, as the remark on `c ∈ collection` and the performance differences between `sum()` and "handwritten" summation show, it is strongly recommended to benchmark implementations which make use of this pattern. 
"""

# ╔═╡ 494722e6-7753-42dc-b10a-68c8ab97aed4
html"""<hr>"""

# ╔═╡ c58b6ca2-3646-4844-b502-5ac3f3c6954a
TableOfContents(title="",aside=true)

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
BenchmarkTools = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
BenchmarkTools = "~1.3.1"
PlutoUI = "~0.7.40"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.2"
manifest_format = "2.0"
project_hash = "115d0295d3eabbe879b9e97789e1079022ebd8d1"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.BenchmarkTools]]
deps = ["JSON", "Logging", "Printf", "Profile", "Statistics", "UUIDs"]
git-tree-sha1 = "4c10eee4af024676200bc7752e536f858c6b8f93"
uuid = "6e4b80f9-dd63-53aa-95a3-0cdb28fa8baf"
version = "1.3.1"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "3d5bf43e3e8b412656404ed9466f1dcbf7c50269"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.4.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "a602d7b0babfca89005da04d89223b867b55319f"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.40"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Profile]]
deps = ["Printf"]
uuid = "9abbd945-dff8-562f-b5e8-e1ebf5ef1b79"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─0898ac67-775a-49db-ad2a-e72f84aaaea3
# ╟─d49a26dd-c503-44aa-982a-ad3dedbec613
# ╟─14d0ec92-43ff-4cc6-9510-b2e84beb104d
# ╠═4bfe6bc8-3c08-443f-bc8e-c6c2ee415ef1
# ╟─1f2c9fe9-7076-40d1-b049-0be760180a1b
# ╟─ba62da3e-723b-4595-b423-ae371f0c01d8
# ╠═4bddcabb-fc8b-4c3f-9d05-db4838ec65e9
# ╠═75d97586-8ac2-48f2-bdad-790a93f2df3b
# ╟─c97d9b7b-27fd-4a62-ba10-1946ee2964cc
# ╠═41ff535c-cdb6-499b-818b-49b32e6c77c4
# ╟─7a9399ff-7684-4f63-8b04-e3b3bb250e37
# ╠═3c7cff9b-c3f2-484b-a4c3-1fb2fa682be1
# ╟─b76b2a71-97ef-4db6-a64b-ebd3b5d6f1e6
# ╠═7f36b41d-a591-44fc-b80f-cf4731d45574
# ╟─6b319342-b0a7-4ef4-a81e-828a8bfd76f8
# ╟─ac9a80bc-1c65-4c7f-a550-3465c7d2039a
# ╠═cc87f4cb-94c1-4607-9fe7-0d551d0f5b4c
# ╟─79c3b7bb-28b4-40c6-be93-386a43134996
# ╠═61dabfa0-e296-4624-afda-a529510a1003
# ╟─fda0443c-0165-496f-a77a-551c98e811cb
# ╠═21a0ed5b-d2ac-4859-832b-a1fc75dd8e3e
# ╟─e0021adb-6878-467a-b015-02170d0031b6
# ╟─af8e6eec-e9f5-4777-bbc1-3f50786cf544
# ╟─fa17546c-225e-4732-9c81-0e25ccd6f507
# ╠═2a6e0171-529f-4ce3-b2a9-8f73fdf8b71e
# ╟─a2f17607-fd3a-4e92-ba4f-75d0e09e7bbf
# ╠═fd4d0549-c6a2-427b-97d8-96c63d26eb24
# ╟─03e23cec-0f66-45a1-8b29-2779607f3a00
# ╟─5e217b3e-ab9a-437a-a7bf-fca8dc604e4e
# ╟─c41ac605-2d45-4730-a2aa-df66136d98a8
# ╠═68946d74-63f3-44fa-b267-54d830ad00ef
# ╠═f8432585-1d5e-41e5-87dd-0f099f770b5c
# ╠═64ebb6a5-a9af-4b9e-8f8c-1a3010c9bd7e
# ╟─05a7038f-f033-426d-9abc-d065ec8c4fa3
# ╠═22bb9b5f-6e99-402c-9b83-6b210b9a3bd5
# ╠═d63ae4aa-2de5-4836-b755-7a055d250e4e
# ╟─0208f08a-6475-4e96-991d-a12d1eda624f
# ╟─958ca00a-4ad9-4de8-a147-2d5942ff0ad6
# ╟─c5fdf045-d6f8-4074-aeba-5bb5469bb5ba
# ╠═a45bca8e-72d6-4853-b995-1372e12e4813
# ╠═c32ecb40-cecf-4c36-9c8c-0432e1cbb67a
# ╟─c270cbcd-a71e-409c-aabf-79ba59aaa156
# ╟─02908d24-6efd-4c48-97f2-893431876942
# ╠═801dee68-b7be-4d9a-a0da-d46e8817d9e8
# ╟─f58cdb62-e1fc-4ed8-ad12-1c74ee4ce353
# ╠═54951111-57a8-4aa8-bc5f-b4b7cbaec33b
# ╠═67af2890-dbc5-4eee-ab2e-cc72074481c8
# ╟─a899b8b1-4782-404b-ba4b-da6c4debb31e
# ╟─b70ee55e-b91a-4420-bf95-8d41b6b78bbc
# ╠═c02e8832-9586-4dff-9a5c-bb318ed44bc3
# ╠═751c89ee-5d2c-4132-bd20-f4522235f35a
# ╠═75e34a9f-60f2-40ad-a193-71cd9eeb5a0b
# ╟─10c5a294-5e21-4d2b-aee8-c180cb06e0d9
# ╠═e885889a-4766-4390-a3b5-63db1e56b5a4
# ╠═f8670360-3d3b-4593-b1f2-ee0f8f75f711
# ╠═5988d3ed-b370-4b7e-8698-f9bbcb376bc9
# ╠═ab28bcc8-f4fb-47b4-8ee6-41948bad0abe
# ╠═ed4c2dc0-f3a9-42fe-8c2c-8fae10585f19
# ╟─92e9756f-30aa-4c2b-8ff2-3c4d832e94f0
# ╠═53712b18-5c51-4e50-b137-b7cfac43bc35
# ╠═1d7a3b43-b9b2-4d60-a7a6-2689967fe473
# ╠═066ccd3e-018c-4f78-a77d-f3bcf2711834
# ╠═dafc4860-d2b9-4940-bf66-cbcd11592027
# ╟─db65bcd3-44f6-4557-bab9-0c14826123ba
# ╠═c48c7899-ee26-45a3-80d6-3e08e3522964
# ╠═509cf0ca-7eb1-42f2-bf00-ffb9702a373a
# ╠═57b4a9d1-94e6-47dd-bb60-e106f546a125
# ╠═5229fe37-6228-4e85-a503-a8355f7694a2
# ╟─2aa2c229-0471-4c9b-8f69-1f63f7753d42
# ╟─7760fc0e-cf94-4fac-a553-ff6061a2e612
# ╠═78408644-96ca-426f-b2d5-0bb683cd0e8f
# ╠═0b29f85b-bdf0-426a-8bc5-4946b4d89f87
# ╟─ebb273d6-1e6d-4e3d-95b1-300b59ababec
# ╟─ae2712cf-6a80-467e-8f99-7786e1f87c0a
# ╠═39794bef-d215-4d7d-ba1a-35953d9049c4
# ╠═f0709de9-a3e1-4c2d-8d6e-5d5b66917337
# ╠═7eee7597-1d4f-4df5-afb2-a4d1d3afe9e5
# ╟─2d6ec664-7203-47ba-a749-76a3c947acf4
# ╠═f1a94bfa-911d-4641-8ffb-8761d687f10c
# ╠═4a4ee1f7-0e46-4ab9-a7ef-cbab5be7592f
# ╟─5ceeff92-9ff7-4515-ba60-fc0909c5233a
# ╟─da54e050-43b8-4683-8374-58004a23a7f5
# ╟─494722e6-7753-42dc-b10a-68c8ab97aed4
# ╠═60941eaa-1aea-11eb-1277-97b991548781
# ╟─c58b6ca2-3646-4844-b502-5ac3f3c6954a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
