package pwm_helper

import (
	"pwm-server/app/bff/pwm/internal/config"
	"pwm-server/app/bff/pwm/internal/server/grpc/service"
	"pwm-server/app/bff/pwm/internal/svc"
)

type (
	Config = config.Config
)

func New(c Config) *service.Service {
	return service.New(svc.NewServiceContext(c))
}

type Workers struct {
	reactions *service.ReactionCommandWorker
	games     *service.GameOutboxWorker
}

func StartWorkers(s *service.Service) *Workers {
	w := &Workers{
		reactions: service.NewReactionCommandWorker(s),
		games:     service.NewGameOutboxWorker(s),
	}
	w.reactions.Start()
	w.games.Start()
	return w
}

func (w *Workers) Stop() {
	if w == nil {
		return
	}
	w.games.Stop()
	w.reactions.Stop()
}
