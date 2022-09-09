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
# time: 2021-11-14 00:57:09 CET
# mode: julia
	serve(port=8000)
# time: 2021-11-14 00:57:45 CET
# mode: julia
	serve(port=8001)
# time: 2021-11-14 00:57:47 CET
# mode: julia
	serve(port=8002)
# time: 2021-11-14 01:09:45 CET
# mode: julia
	publish()
# time: 2021-11-14 11:20:03 CET
# mode: julia
	serve(port=8000)
# time: 2021-11-14 13:13:41 CET
# mode: julia
	publish()
# time: 2021-11-14 15:12:17 CET
# mode: julia
	serve(port=8000)
# time: 2021-11-14 17:28:06 CET
# mode: julia
	publish()
# time: 2021-11-15 19:02:53 CET
# mode: julia
	serve()
# time: 2021-11-15 19:04:20 CET
# mode: julia
	publish()
# time: 2021-11-30 00:06:27 CET
# mode: julia
	serve()
# time: 2021-12-01 22:49:00 CET
# mode: julia
	publish()
# time: 2021-12-01 23:17:53 CET
# mode: julia
	serve()
# time: 2021-12-02 09:52:42 CET
# mode: julia
	publish()
# time: 2022-02-08 16:56:13 CET
# mode: julia
	upload()
# time: 2022-02-08 16:56:41 CET
# mode: julia
	publish()
# time: 2022-02-08 16:57:49 CET
# mode: shell
	e
# time: 2022-02-08 16:59:28 CET
# mode: julia
	serve()
# time: 2022-02-08 17:01:11 CET
# mode: julia
	publish()
# time: 2022-02-09 13:48:12 CET
# mode: julia
	serve()
# time: 2022-02-09 14:11:33 CET
# mode: shell
	git commit -am "fix rss"
# time: 2022-02-09 14:11:39 CET
# mode: julia
	publish()
# time: 2022-02-10 01:10:36 CET
# mode: pkg
	add ThreadingUtilities
# time: 2022-02-10 01:10:56 CET
# mode: julia
	using ThreadingUtilities
# time: 2022-02-15 23:18:01 CET
# mode: julia
	publish
# time: 2022-02-15 23:18:04 CET
# mode: julia
	publish()
# time: 2022-06-28 22:40:31 CEST
# mode: julia
	serve()
# time: 2022-06-28 23:33:30 CEST
# mode: julia
	upload()
# time: 2022-06-28 23:33:44 CEST
# mode: julia
	publish()
# time: 2022-08-31 09:57:40 CEST
# mode: julia
	upload()
# time: 2022-08-31 09:58:08 CEST
# mode: julia
	publish()
# time: 2022-09-08 14:12:54 CEST
# mode: julia
	serve()
# time: 2022-09-08 14:13:22 CEST
# mode: julia
	serve(port=8101)
# time: 2022-09-08 14:13:27 CEST
# mode: help
	serve
# time: 2022-09-08 14:13:36 CEST
# mode: julia
	serve(port=7000)
# time: 2022-09-08 14:13:43 CEST
# mode: julia
	serve(port=8500)
# time: 2022-09-08 14:58:29 CEST
# mode: julia
	publish()
# time: 2022-09-08 15:01:16 CEST
# mode: shell
	git st
# time: 2022-09-08 15:01:18 CEST
# mode: shell
	git out
# time: 2022-09-08 15:01:30 CEST
# mode: shell
	git st __site/
# time: 2022-09-08 15:01:36 CEST
# mode: shell
	ls __site/
# time: 2022-09-08 15:01:40 CEST
# mode: shell
	ls -lrt __site/
# time: 2022-09-08 23:46:40 CEST
# mode: julia
	serve()
# time: 2022-09-08 23:54:30 CEST
# mode: shell
	git out
# time: 2022-09-08 23:54:32 CEST
# mode: julia
	serve()
# time: 2022-09-09 00:23:06 CEST
# mode: shell
	git out
# time: 2022-09-09 00:23:08 CEST
# mode: julia
	serve()
# time: 2022-09-09 00:26:34 CEST
# mode: shell
	mkdir _assets/code
# time: 2022-09-09 00:26:39 CEST
# mode: julia
	serve()
# time: 2022-09-09 10:48:47 CEST
# mode: shell
	cp ~/unionize.html _assets/
# time: 2022-09-09 10:48:51 CEST
# mode: julia
	serve()
# time: 2022-09-09 11:00:12 CEST
# mode: julia
	publish()
