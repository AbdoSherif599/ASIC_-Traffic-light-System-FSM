all: visualize

visualize: simulate
	gtkwave test.fst

simulate: compile
	vvp test.vvp -fst

compile:
	iverilog -otest.vvp tb.v traffic.v

clean:
	rm -f test.fst test.vpp

report: report.md
	pandoc report.md -o report.pdf --filter pandoc-plantuml

report2: report2.md
	pandoc report2.md -o report.pdf

report3: report3.md
	pandoc report3.md -o report.pdf