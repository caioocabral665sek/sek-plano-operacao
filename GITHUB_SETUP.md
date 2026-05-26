# GitHub Setup — Plano de Ação

Repositório: https://github.com/caioocabral665sek/sek-plano-operacao

## ✅ Status Atual

- [x] Repositório criado
- [x] Código commit inicial
- [x] README + ROADMAP + documentação
- [x] Scripts setup automáticos
- [ ] GitHub Project criado
- [ ] Issues criadas para cada phase
- [ ] GitHub Actions workflows configurados

---

## 🚀 Próximos Passos

### 1. Criar GitHub Project

1. Acesse https://github.com/caioocabral665sek/sek-plano-operacao
2. Clique em **"Projects"** (abas no topo)
3. **"New Project"**
   - Name: "Plano de Operação Roadmap"
   - Template: "Table" (para melhor visualização)
   - Visibility: Public
4. **Create**

### 2. Criar Issues para Phase 1 (MVP)

Issue template:
```markdown
### [PHASE 1] Backend: Graph API Authentication
- [ ] Função _plano_ops_graph_token()
- [ ] Testa autenticação com credenciais
- [ ] Retorna access token para SharePoint

**Assignee:** @caioocabral665sek
**Labels:** phase-1, feature, backend
**Milestone:** Phase 1 - MVP
**Priority:** High
```

Use o script abaixo para criar automaticamente:

```bash
# Script: create-issues.sh (em setup/)
#!/bin/bash
TOKEN="seu_token_aqui"
REPO="caioocabral665sek/sek-plano-operacao"

issues=(
  "Backend: Graph API Authentication"
  "Backend: SharePoint Document Download"
  "Backend: DOCX Text Extraction"
  "Backend: Claude Analysis Integration"
  "Backend: Cache Management (7-day TTL)"
  "Frontend: Portal Section 'Plano de Operacao'"
  "Frontend: Analyze Button + Loading Spinner"
  "Frontend: Polling for Results"
  "Frontend: Results Display + CSS Styling"
  "Setup: install.sh Script"
  "Setup: configure-sharepoint.sh Script"
  "Setup: Documentation (SETUP.md, API.md)"
)

for issue in "${issues[@]}"; do
  curl -s -X POST "https://api.github.com/repos/$REPO/issues" \
    -H "Authorization: token $TOKEN" \
    -d "{\"title\": \"$issue\", \"labels\": [\"phase-1\", \"feature\"], \"body\": \"\"}"
done
```

### 3. Criar Milestones

Para cada phase, crie um Milestone:

1. **Settings → Milestones → Create a milestone**
   - Title: "Phase 1 - MVP"
   - Description: "Backend + Frontend + Setup scripts"
   - Due date: 2026-05-31 (opcional)

2. Repetir para Phase 2, 3, 4

### 4. GitHub Actions Workflows

Criar arquivo `.github/workflows/ci.yml`:

```yaml
name: CI/Tests

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-python@v4
        with:
          python-version: '3.9'
      - run: pip install -r setup/requirements.txt
      - run: python -m pytest tests/
```

### 5. Configurar Branch Protection Rules

**Settings → Branches → Add rule**
- Branch name pattern: `main`
- Require a pull request before merging: ✓
- Require status checks to pass: ✓
- Require branches to be up to date: ✓

---

## 📋 Quick Links

- **Repo:** https://github.com/caioocabral665sek/sek-plano-operacao
- **Issues:** https://github.com/caioocabral665sek/sek-plano-operacao/issues
- **Discussions:** https://github.com/caioocabral665sek/sek-plano-operacao/discussions
- **Projects:** https://github.com/caioocabral665sek/sek-plano-operacao/projects

---

## 🔄 Fluxo de Contribuição

```
1. Clone o repo:
   git clone https://github.com/caioocabral665sek/sek-plano-operacao.git

2. Escolha uma issue no Project
   
3. Crie uma branch:
   git checkout -b feature/issue-123

4. Faça o trabalho + testes
   pytest tests/

5. Commit + push:
   git commit -m "feat: #123 - Description"
   git push origin feature/issue-123

6. Abra PR
   Descreva mudanças, reference a issue

7. CI roda automaticamente
   Se passar → merge manual ou auto-merge
```

---

## 📊 Rastreamento de Progresso

Adicione issues ao Project:
1. Vá para **Projects → SEU_PROJECT**
2. **"Add item"** → Selecione issue
3. Configure status: "Todo" → "In Progress" → "Done"

Ou acompanhe no board: https://github.com/caioocabral665sek/sek-plano-operacao/projects

---

**Configurado em:** 2026-05-26  
**Maintainer:** caio.cabral@sek.io
