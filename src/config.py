"""
Configuração centralizada para Plano de Operação
Lê variáveis de ambiente em /etc/sek-plano-ops/config.env
"""
import os

# Carregar config.env se existir
CONFIG_FILE = "/etc/sek-plano-ops/config.env"
if os.path.exists(CONFIG_FILE):
    with open(CONFIG_FILE, 'r') as f:
        for line in f:
            if line.strip() and not line.startswith('#'):
                key, val = line.strip().split('=', 1)
                val = val.strip('"\'')
                os.environ[key] = val

# SharePoint
PLANO_OPS_SP_TENANT  = os.environ.get("PLANO_OPS_SP_TENANT", "")
PLANO_OPS_SP_CLI_ID  = os.environ.get("PLANO_OPS_SP_CLI_ID", "")
PLANO_OPS_SP_CLI_SEC = os.environ.get("PLANO_OPS_SP_CLI_SEC", "")
PLANO_OPS_SP_HOST    = os.environ.get("PLANO_OPS_SP_HOST", "proofcrm.sharepoint.com")
PLANO_OPS_SP_SITE    = os.environ.get("PLANO_OPS_SP_SITE", "SOCPROOF")
PLANO_OPS_SP_FOLDER  = os.environ.get("PLANO_OPS_SP_FOLDER",
                                       "Documentos Compartilhados/Clientes, Governança e Controles/Plano de Operação")
PLANO_OPS_LOCAL_DIR  = os.environ.get("PLANO_OPS_LOCAL_DIR", "/opt/sek-paloalto-agent/planos_operacao")
PLANO_OPS_CACHE_TTL  = int(os.environ.get("PLANO_OPS_CACHE_TTL", 7 * 24 * 3600))

# Mapeamento cliente → pasta no SharePoint
PLANO_OPS_CLIENT_MAP = {
    "materdei":      "Mater Dei",
    "machado-meyer": "Machado Meyer",
    "bma":           "BMA",
    "pifpaf":        "Pif Paf",
    "arke":          "Arke",
    "grupomulti":    "Grupo Multi",
    "suzano":        "Suzano",
    "waapvtal":      "VTal",
}

# Paths
AGENT_DIR = "/opt/sek-paloalto-agent"
CACHE_DIR = f"{AGENT_DIR}/cache"
CLAUDE_BIN = "/usr/local/bin/claude"
