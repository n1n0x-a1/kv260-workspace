package util

import (
	"bufio"
	"fmt"
	"io"
	"net"
	"os"
	"os/signal"
	"syscall"
)

//  1. resolve tcp4 and connect to server
//  2. send cli command to remote server
//  3. continuously read each byte send by server till reach EOF
//  4. (optional) only for app conditional :
//     -- server will send ~ to check if client is connected (so won't print ~)
//     -- client can initiate SIGTSTP to stop the running model
//     -- client can input reply when seeing [input]
func tcp_client(service string, rpc string) {

	tcpAddr, err := net.ResolveTCPAddr("tcp4", service)
	checkError(err)

	conn, err := net.DialTCP("tcp", nil, tcpAddr)
	checkError(err)

	_, err = conn.Write([]byte(rpc))
	checkError(err)

	reply := []byte(".")
	input_mark := make([]byte, 8)
	sigc := make(chan os.Signal, 1)
	reader := bufio.NewReader(os.Stdin)
	for err != io.EOF {
		_, err = io.ReadFull(conn, reply)
		if string(reply) != "~" {
			fmt.Print(string(reply))
		}
		signal.Notify(sigc, syscall.SIGTSTP)

		if len(sigc) != 0 {
			conn.Write([]byte("~\n"))
			<-sigc
		}

		input_mark = input_mark[1:]
		input_mark = append(input_mark, reply[0])
		if string(input_mark) == "[input]\n" {
			text, _ := reader.ReadString('\n')
			_, err = conn.Write([]byte(text))
		}

	}
}

func checkError(err error) {
	if err != nil {
		fmt.Fprintf(os.Stderr, "Fatal error: %s\n", err.Error())
		os.Exit(1)
	}
}
