# Roadmap — Plano de Ação Plano de Operação

## 📊 Status Geral
- [x] MVP: Análise básica por cliente (Feature completa em 2026-05-26)
- [ ] Phase 2: Comparativo histórico + trends
- [ ] Phase 3: Integração com Freshdesk (criar tickets automaticamente)
- [ ] Phase 4: Dashboard executivo com KPIs

---

## ✅ Phase 1: MVP (CONCLUÍDO — 2026-05-26)

**Objetivo:** Análise inteligente de gaps no Plano de Operação por cliente.

### Backend
- [x] Autenticação SharePoint Graph API (tenant/client_id/secret)
- [x] Download automático .docx do Plano de Operação
- [x] Extração de texto (python-docx)
- [x] Análise com Claude Sonnet (via subprocess)
- [x] Cache 7 dias (JSON em disco)
- [x] Fallback para arquivo local se SharePoint falhar
- [x] Testes unitários

### Frontend
- [x] Seção "Plano de Operação" em `/portal/<slug>`
- [x] Botão "Analisar" com loading spinner
- [x] Polling (3s) para capturar resultado
- [x] Exibição formatada (resumo, gaps, oportunidades, recomendações)
- [x] CSS customizado (tema dark portal)
- [x] Botão "♻" para forçar reanálise

### Setup
- [x] Script `install.sh` (clona, instala, integra)
- [x] Script `configure-sharepoint.sh` (credenciais uma única vez)
- [x] Documentação SETUP.md
- [x] Integração com web_sentinel.py existente
- [x] GitHub repo + Actions CI/CD

### Mapeamento de Clientes
- [x] Mater Dei ← `materdei`
- [x] Machado Meyer ← `machado-meyer`
- [x] BMA ← `bma`
- [x] Pif Paf ← `pifpaf`
- [x] Arke ← `arke`
- [x] Grupo Multi ← `grupomulti`
- [x] Suzano ← `suzano`
- [x] VTal ← `waapvtal`

---

## 📅 Phase 2: Comparativo Histórico (Q3 2026)

**Objetivo:** Rastrear evolução de gaps ao longo do tempo.

### Issues
1. **Adicionar versionamento de análises**
   - [ ] Salvar histórico de análises (data + resultado)
   - [ ] Comparar análise atual vs. 30 dias atrás
   - [ ] Identificar gaps novos vs. gaps resolvidos

2. **Dashboard de trends**
   - [ ] Gráfico: evolução de gap count por cliente
   - [ ] Timeline: quando foi detectado cada gap
   - [ ] Métrica: % de gaps resolvidos (comparável)

3. **Alertas de degradação**
   - [ ] Se gaps aumentaram na última análise, avisar
   - [ ] Se opportunity não foi explorada, lembrar

### Estimativa: 2 semanas

---

## 🎟️ Phase 3: Integração Freshdesk (Q4 2026)

**Objetivo:** Criar tickets automaticamente de gaps/oportunidades.

### Issues
1. **Mapeamento: gap → tipo de ticket**
   - [ ] Gap crítico → ticket URGENT
   - [ ] Opportunity → ticket planning
   - [ ] Risco operacional → ticket segurança

2. **Criar ticket automaticamente**
   - [ ] POST `/api/plano-ops/<slug>/create-ticket`
   - [ ] Descrição com resumo do gap
   - [ ] Anexar resultado JSON completo
   - [ ] Atribuir ao cliente correto em Freshdesk
   - [ ] Linkar ticket em Freshdesk ao resultado no portal

3. **Follow-up automático**
   - [ ] Se ticket aberto > 14 dias, notificar
   - [ ] Se gap foi resolvido (nova análise), comentar no ticket

### Estimativa: 3 semanas

---

## 📊 Phase 4: Dashboard Executivo (Q4 2026 / Q1 2027)

**Objetivo:** KPIs e relatórios para vendas/gestão.

### Issues
1. **Métricas de oportunidade**
   - [ ] Total opportunities por cliente
   - [ ] Opportunities resolvidas vs. em aberto
   - [ ] ROI estimado se fechar opportunity
   - [ ] Ranking: clientes com maior potencial de upsell

2. **Dashboard executivo**
   - [ ] Gráfico: distribuição de gaps por tipo
   - [ ] Tabela: oportunidades priorizadas (top 10)
   - [ ] Heatmap: risco por cliente
   - [ ] Filtros: por cliente, por tipo de gap, por impacto

3. **Relatório mensal PDF**
   - [ ] Gerar automaticamente dia 1 do mês
   - [ ] Incluir: resumo, gaps, oportunidades, recomendações
   - [ ] Enviar por email para gestores

### Estimativa: 4 semanas

---

## 🔧 Tech Debt & Improvements

### Priority: Alto
- [ ] Adicionar testes integração (SharePoint real)
- [ ] Rate limiting na API (evitar abuso)
- [ ] Validação mais robusta de JSON da análise Claude
- [ ] Retry automático se Claude timeout

### Priority: Médio
- [ ] Suporte a múltiplas versões de Plano (v3.9, v4.0, etc)
- [ ] Detectar automaticamente versão do documento
- [ ] Armazenar análises antigas (não apenas cache)
- [ ] UI: melhorar loading states + error messages

### Priority: Baixo
- [ ] Suporte a outros formatos (Word97, PDF)
- [ ] Análise de imagens dentro do .docx
- [ ] Multi-idioma (português/inglês)

---

## 📌 Labels GitHub

Usar para organizar issues:

- `phase-1` — MVP (atual)
- `phase-2` — Comparativo histórico
- `phase-3` — Integração Freshdesk
- `phase-4` — Dashboard executivo
- `bug` — Problemas
- `feature` — Nova funcionalidade
- `tech-debt` — Melhorias técnicas
- `documentation` — Docs
- `high-priority` — Urgente
- `good-first-issue` — Bom para iniciantes

---

## 📈 Success Metrics (Phase 1)

- [x] Tempo de análise < 30s (primeira), < 1s (cache)
- [x] Taxa de sucesso SharePoint > 95% (com fallback local)
- [x] Análise Claude útil (checado manualmente com Mater Dei)
- [x] Cache funciona (7 dias, sem re-análise)
- [x] UI responsiva (< 3s para exibir resultado)
- [x] 0 erros em 24h de produção

---

## 🤝 How to Contribute

```bash
# Escolha uma issue do Roadmap
# Crie uma branch
git checkout -b feature/issue-123

# Implemente + teste
pytest tests/

# Commit + push
git commit -m "feat: #123 - Descrição"
git push origin feature/issue-123

# Abra PR
# CI roda automaticamente
# Merge após review
```

---

**Last Updated:** 2026-05-26  
**Next Review:** 2026-06-09 (Phase 1 retrospective + Phase 2 planning)
