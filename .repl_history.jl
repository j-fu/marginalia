# time: 2021-11-11 22:08:40 CET
# mode: pkg
	serve
# time: 2021-11-11 22:08:51 CET
# mode: julia
	using Franklin
# time: 2021-11-11 22:08:58 CET
# mode: julia
	serve()
# time: 2021-11-13 23:26:52 CET
# mode: shell
	rm QUARRY
# time: 2021-11-13 23:26:55 CET
# mode: julia
	serve()
# time: 2021-11-13 23:27:01 CET
# mode: shell
	ls
# time: 2021-11-13 23:27:35 CET
# mode: shell
	rm __site/QUARRY
# time: 2021-11-13 23:27:40 CET
# mode: shell
	rm -r __site/QUARRY
# time: 2021-11-13 23:27:42 CET
# mode: julia
	serve()
# time: 2021-11-13 23:27:57 CET
# mode: julia
	serve(port=8000)
# time: 2021-11-13 23:28:03 CET
# mode: julia
	serve(port=8001)
# time: 2021-11-13 23:31:18 CET
# mode: julia
	serve()
# time: 2021-11-13 23:39:19 CET
# mode: julia
	serve(port=8001)
# time: 2021-11-13 23:41:00 CET
# mode: julia
	serve(port=8000)
# time: 2021-11-14 00:16:10 CET
# mode: julia
	publish()
# time: 2021-11-14 00:22:30 CET
# mode: julia
	serve(port=8000)
# time: 2021-11-14 00:25:23 CET
# mode: julia
	publish()
# time: 2021-11-14 00:27:34 CET
# mode: julia
	serve(port=8000)
# time: 2021-11-14 00:34:30 CET
# mode: shell
	rg built
# time: 2021-11-14 00:34:44 CET
# mode: shell
	rg built -tmd
# time: 2021-11-14 00:35:09 CET
# mode: shell
	cd layout
# time: 2021-11-14 00:35:19 CET
# mode: shell
	cd _layout/
# time: 2021-11-14 00:35:22 CET
# mode: shell
	rg built -tmd
# time: 2021-11-14 00:35:23 CET
# mode: shell
	rg built
# time: 2021-11-14 00:42:50 CET
# mode: shell
	ls
# time: 2021-11-14 00:42:54 CET
# mode: shell
	cd ..
# time: 2021-11-14 00:42:55 CET
# mode: shell
	ls
# time: 2021-11-14 00:43:02 CET
# mode: shell
	git add README.md
# time: 2021-11-14 00:43:04 CET
# mode: shell
	git push
# time: 2021-11-14 00:43:13 CET
# mode: shell
	git commit -m "readme"
# time: 2021-11-14 00:43:15 CET
# mode: shell
	git push
# time: 2021-11-14 00:44:12 CET
# mode: julia
	serve(port=8000)
# time: 2021-11-14 00:49:55 CET
# mode: julia
	publish()
