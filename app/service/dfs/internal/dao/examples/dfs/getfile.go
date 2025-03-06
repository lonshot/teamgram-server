package main

import (
	"context"
	"flag"
	"os"

	"github.com/teamgram/marmota/pkg/commands"
	"pwm-server/app/service/dfs/internal/config"
	"pwm-server/app/service/dfs/internal/dao"
	"github.com/zeromicro/go-zero/core/conf"

	"github.com/zeromicro/go-zero/core/logx"
)

var configFile = flag.String("f", "etc/dfs.yaml", "the config file")

func main() {
	commands.Run(New())
}

type Server struct {
	dao *dao.Dao
}

func New() *Server {
	s := new(Server)
	return s
}

func (s *Server) Initialize() error {
	var c config.Config
	conf.MustLoad(*configFile, &c)

	logx.Infov(c)
	s.dao = dao.New(c)
	return nil
}

func (s *Server) RunLoop() {
	defer func() {
		s.Destroy()
		os.Exit(0)
	}()

	fileInfo, err := s.dao.GetFileInfo(context.Background(), 7997959636588162716, -8695032368284712706)
	if err != nil {
		logx.Errorf("open error: %v", err)
		// panic(err)
		return
	} else {
		logx.Debugf("fileInfo: %v", fileInfo)
	}

}

func (s *Server) Destroy() {
	// s.dao.Close()
}
