# SEK Plano de Operação — Análise Inteligente de Gaps

Ferramenta automatizada para analisar Planos de Operação dos clientes contra tecnologias atualmente monitoradas, identificando gaps, riscos e oportunidades de upsell.

## 🎯 Objetivo

Comparar o **Plano de Operação** (documento SharePoint) de cada cliente com as **tecnologias monitoradas** (PA, CS, FGT, F5XC), fornecendo uma análise estruturada de:
- ✅ Cobertura atual
- ⚠️ Gaps identificados  
- 💡 Oportunidades de melhoria/upsell
- 🎯 Top 3 recomendações priorizadas
- 🚨 Riscos operacionais

## 🚀 Quick Start (Automático)

```bash
git clone https://github.com/caioocabral665sek/sek-plano-operacao.git
cd sek-plano-operacao
./setup/install.sh                    # Setup automático
./setup/configure-sharepoint.sh       # Configura credenciais SharePoint uma única vez
```

Pronto! Acesse `http://sekhealthcheck/portal/<cliente>` e clique em **"Analisar"**.

## 📋 Fluxo Automático

```
Usuário clica "Analisar"
    ↓
Sistema valida credenciais SharePoint (env)
    ↓
Download .docx do Plano de Operação (Graph API)
    ↓
Extração de texto (python-docx)
    ↓
Análise com Claude Sonnet (via subprocess)
    ↓
Estruturação JSON dos resultados
    ↓
Cache por 7 dias
    ↓
Exibição no portal com polling
```

## 🔐 Autenticação (Automática)

### Setup Único
```bash
./setup/configure-sharepoint.sh
# Pede uma única vez:
# - Tenant ID do proofcrm (ex: "00001111-2222-3333-4444-555555666666")
# - Client ID do App Registration Azure AD
# - Client Secret
# Armazena em: /etc/sek-plano-ops/config.env (chmod 600)
```

### Uso
Sistema lê automaticamente de `/etc/sek-plano-ops/config.env` — nenhuma entrada manual posterior.

## 📦 Estrutura

```
sek-plano-operacao/
├── README.md                  # Este arquivo
├── ROADMAP.md                 # Plano de ação (GitHub Projects)
├── setup/
│   ├── install.sh             # Instalação completa
│   ├── configure-sharepoint.sh # Setup credenciais (executa uma única vez)
│   └── requirements.txt
├── src/
│   ├── plano_ops_api.py       # Rotas Flask + funções backend
│   ├── sharepoint_client.py   # Cliente Graph API
│   ├── docx_parser.py         # Extração de texto de .docx
│   ├── claude_analyzer.py     # Integração Claude
│   └── cache_manager.py       # Cache com TTL
├── docs/
│   ├── API.md                 # Documentação de rotas
│   ├── SETUP.md               # Guia detalhado de instalação
│   ├── ARCHITECTURE.md        # Arquitetura do sistema
│   └── SHAREPOINT_CONFIG.md   # Como registrar App Azure AD
├── tests/
│   ├── test_api.py
│   ├── test_sharepoint.py
│   └── test_claude.py
├── .github/workflows/
│   ├── ci.yml                 # Testes automáticos
│   └── deploy.yml             # Deploy automático
└── .env.example               # Template de variáveis

```

## 🔧 Configuração (Automática)

### 1️⃣ Setup Inicial (uma única vez)
```bash
./setup/install.sh
```

Isso:
- [ ] Clona/faz pull do repo
- [ ] Instala dependências Python (`python-docx`, etc)
- [ ] Integra código em `web_sentinel.py` existente
- [ ] Cria diretório de cache
- [ ] Testa conexão com Flask

### 2️⃣ Configurar SharePoint (uma única vez)
```bash
./setup/configure-sharepoint.sh
```

Passo a passo:
- [ ] Pede Tenant ID proofcrm
- [ ] Pede Client ID do App Azure AD
- [ ] Pede Client Secret
- [ ] Testa autenticação Graph API
- [ ] Armazena em `/etc/sek-plano-ops/config.env` (seguro)
- [ ] Valida acesso ao site SOCPROOF

### 3️⃣ Usar (nenhuma configuração manual)
- Acesse portal
- Clique "Analisar" em qualquer cliente mapeado
- Resultado aparece em segundos (ou carregado de cache de 7 dias)

## 📊 Clientes Suportados

Mapeamento automático (em `src/config.py`):
- `materdei` → Mater Dei
- `machado-meyer` → Machado Meyer
- `bma` → BMA
- `pifpaf` → Pif Paf
- `arke` → Arke
- `grupomulti` → Grupo Multi
- `suzano` → Suzano
- `waapvtal` → VTal

**Adicionar novo cliente:** Edite `_PLANO_OPS_CLIENT_MAP` em `src/config.py` e faça commit.

## 🧠 Análise com IA

Claude Sonnet 4.6 analisa automaticamente:

```json
{
  "resumo_plano": "Escopo do plano de operação",
  "cobertura_atual": ["tecnologia 1", "tecnologia 2"],
  "gaps": [
    {
      "gap": "Email Security não monitorado",
      "impacto": "alto",
      "detalhe": "Plano menciona Proofpoint, não temos visibilidade"
    }
  ],
  "oportunidades": [
    {
      "titulo": "SIEM Integration",
      "descricao": "Correlação de eventos de múltiplas fontes",
      "valor": "alto"
    }
  ],
  "riscos_operacionais": ["Falta visibilidade em email"],
  "recomendacoes": [
    {
      "prioridade": 1,
      "acao": "Propor demo SIEM",
      "justificativa": "Alinha com escopo do plano"
    },
    {"prioridade": 2, "acao": "...", "justificativa": "..."},
    {"prioridade": 3, "acao": "...", "justificativa": "..."}
  ]
}
```

## 📈 Cache Inteligente

- **TTL:** 7 dias (configurável em `src/config.py`)
- **Localização:** `/opt/sek-paloalto-agent/cache/plano_ops_<slug>.json`
- **Reset manual:** Botão "♻" no portal reanálisa agora
- **Auto-refresh:** Análise antiga? Clique "Analisar" para atualizar

## 🔄 CI/CD Automático

GitHub Actions (`.github/workflows/`):
- **CI:** Testes + linting em cada push
- **Deploy:** Auto-deploy para servidor ao fazer merge em `main`

```bash
git push origin feature/novo-cliente
# → CI testa automaticamente
# → Merge em main
# → Deploy automático em 2min
```

## 📚 Documentação

- [`ROADMAP.md`](ROADMAP.md) — Plano de ação com issues
- [`docs/SETUP.md`](docs/SETUP.md) — Guia detalhado
- [`docs/API.md`](docs/API.md) — Referência de rotas
- [`docs/SHAREPOINT_CONFIG.md`](docs/SHAREPOINT_CONFIG.md) — Setup Azure AD
- [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) — Design técnico

## 🛠️ Troubleshooting

### Erro: "credenciais_nao_configuradas"
```bash
sudo /etc/sek-plano-ops/config.env && cat /etc/sek-plano-ops/config.env
# Se vazio, execute:
./setup/configure-sharepoint.sh
```

### Erro: "Plano não encontrado"
- [ ] Arquivo `.docx` existe em SharePoint?
- [ ] Cliente está em `_PLANO_OPS_CLIENT_MAP`?
- [ ] Pasta no SharePoint é `Mater Dei` (com acento)?

### Cache muito antigo?
Clique no botão ♻ para forçar reanálise.

## 🤝 Contribuir

```bash
git checkout -b feature/nome-da-feature
# Edite código, teste
git commit -m "feat: descrição"
git push origin feature/nome-da-feature
# Abra PR — CI roda automaticamente
```

## 📄 Licença

SEK Internal — Uso restrito.

## 📞 Suporte

Abra uma issue em GitHub ou contate `caio.cabral@sek.io`.

---

**Status:** ✅ Em produção  
**Última atualização:** 2026-05-26  
**Maintainer:** [@caioocabral665sek](https://github.com/caioocabral665sek)
