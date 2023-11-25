import { Configuration, V0alpha2Api } from "@ory/client";
import { edgeConfig } from "@ory/integrations/next";
export const kratos = new V0alpha2Api(new Configuration(edgeConfig));
