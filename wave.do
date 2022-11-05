onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/dut/clock
add wave -noupdate /tb/dut/reset

add wave -noupdate -divider {fluxo IN e OUT}
add wave -noupdate /tb/dut/din
add wave -noupdate /tb/dut/dout

add wave -noupdate  -radix hexadecimal /tb/dut/reg_din

add wave -noupdate -divider {PROGRAMACAO}
add wave -noupdate -radix unsigned /tb/dut/prog

add wave -noupdate -divider {PADROES}
add wave -noupdate  /tb/dut/valid_p1
add wave -noupdate  -radix hexadecimal /tb/dut/p1
add wave -noupdate /tb/dut/valid_p2
add wave -noupdate -radix hexadecimal /tb/dut/p2
add wave -noupdate -color red /tb/dut/valid_p3
add wave -noupdate -color red -radix hexadecimal /tb/dut/p3

add wave -noupdate -divider {ALARME}
add wave -noupdate /tb/dut/alarme
add wave -noupdate -radix unsigned /tb/dut/cont

add wave -noupdate -divider {sinais internos}
add wave -noupdate /tb/dut/EA
add wave -noupdate /tb/dut/match_p1
add wave -noupdate /tb/dut/match_p2
add wave -noupdate /tb/dut/match_p3
add wave -noupdate -divider {__}
add wave -noupdate /tb/dut/match

add wave -noupdate -divider {test bench}
add wave -noupdate -radix unsigned /tb/conta_tempo

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2051 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 110
configure wave -valuecolwidth 50
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 2000
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits us
update
WaveRestoreZoom {0 ns} {4200 ns}