package auth

import (
	"context"

	"github.com/gen1us2k/shorts/config"
	client "github.com/ory/keto-client-go"
)

type (
	Keto struct {
		AccessControl
		writeClient *client.APIClient
		readClient  *client.APIClient
		config      *config.ShortsConfig
	}
)

func NewKeto(c *config.ShortsConfig) *Keto {
	k := &Keto{config: c}
	configuration := client.NewConfiguration()
	configuration.Servers = []client.ServerConfiguration{
		{
			URL: c.KetoWriteAPI,
		},
	}
	k.writeClient = client.NewAPIClient(configuration)
	conf := client.NewConfiguration()
	conf.Servers = []client.ServerConfiguration{
		{
			URL: c.KetoReadAPI,
		},
	}
	k.readClient = client.NewAPIClient(conf)
	return k
}

func (k *Keto) GrantAccess(obj, to string) error {
	q := *client.NewRelationQuery()
	q.SetNamespace(k.config.KetoNamespace)
	q.SetObject(obj)
	q.SetRelation("access")
	q.SetSubjectId(to)
	_, _, err := k.writeClient.WriteApi.CreateRelationTuple(context.Background()).RelationQuery(q).Execute()
	return err
}
func (k *Keto) CheckAccess(obj, to string) bool {
	check, _, err := k.readClient.ReadApi.GetCheck(context.Background()).
		Namespace(k.config.KetoNamespace).
		Object(obj).
		Relation("access").
		SubjectId(to).
		Execute()
	if err != nil {
		return false
	}
	return check.Allowed

}
