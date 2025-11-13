# 💧 Roadmap — App "Contador de Água" (Flutter)

Um projeto baseado no contador inicial do Flutter, evoluído para um **contador de copos d’água diários**.  
O objetivo é aprender Flutter de forma progressiva — do básico à personalização — sem frameworks avançados de estado.

---

## 🧩 Fase 1 — Fundamentos do Flutter
> 🎯 **Objetivo:** entender a estrutura do app e manipular o estado básico.

- Estrutura de widgets (`Scaffold`, `AppBar`, `Column`, `FloatingActionButton`)
- Atualização de estado com `setState`
- Boas práticas de organização de código

**Checklist:**
- [x] Criar contador simples de copos de água
- [x] Implementar **incremento**, **decremento** e **reset**
- [ ] Exibir valor atual (ex: “Você bebeu 3 copos hoje”)
- [ ] Mostrar alerta ou texto quando o valor for 0 (“Hora de se hidratar!”)
- [x] Adicionar botão no `AppBar` para abrir o **modal de configurações** (pode ser `showModalBottomSheet`)


---

## ⚙️ Fase 2 — Configurações e Personalização
> 🎯 **Objetivo:** permitir que o usuário configure a meta e o valor de cada copo.

- Formulários simples (`TextField`, `DropdownButton`, `ElevatedButton`)
- Validação de entrada de dados
- Persistência com `SharedPreferences`

**Checklist:**
- [x] Criar **modal de configurações** (pode ser um `BottomSheet`)
- [x] Permitir configurar:
  - [x] Meta diária (em ml ou L)
  - [x] Quantidade de água por copo (ex: 200ml)
  - [x] Incrementos/decrementos por clique
  - [x] Unidade (ml ou L)
- [ ] Salvar as configurações com `SharedPreferences`
- [x] Criar configuração **padrão (default)** se nenhuma for salva
- [x] Mostrar meta atual e progresso no topo da tela principal


---

## 🌊 Fase 3 — Feedback Visual e Experiência
> 🎯 **Objetivo:** adicionar elementos visuais simples para representar o progresso da meta.

- `LinearProgressIndicator` ou `CircularProgressIndicator`
- Layouts visuais (`Row`, `Wrap`, `Container`, `Image.asset`)
- Animações simples com `AnimatedContainer`

**Checklist:**
- [x] Mostrar barra de progresso da meta (ex: 50% da meta atingida)
- [ ] Exibir visual com **copos de água** (ex: um ícone por incremento)
- [ ] Substituir copos por **garrafa** quando atingir 1L
- [ ] Atualizar barra/ícones em tempo real conforme incrementa
- [ ] Adicionar um botão “Zerar dia” (reset diário)

🧠 **Dica:** ícones padrão do Flutter (`Icons.local_drink`, `Icons.water_drop`).

---

## ☀️ Fase 4 — Qualidade de Vida e Persistência
> 🎯 **Objetivo:** manter os dados do dia e melhorar a experiência do usuário.

- Armazenar e recuperar dados com `SharedPreferences`
- Formatar valores (ml ↔ L)
- Pequenas animações e feedbacks

**Checklist:**
- [ ] Salvar valor atual ao fechar o app e restaurar ao abrir
- [ ] Mostrar data atual e zerar contador automaticamente no dia seguinte
- [ ] Adicionar pequena animação ao atingir a meta (ex: mudar cor da barra)
- [ ] Exibir mensagem de parabéns quando completar a meta
- [ ] Criar opção “Modo noturno” simples com `ThemeMode`


---

## 🧮 Progresso Geral
| Fase | Descrição | Tarefas | Concluídas |
|------|------------|----------|-------------|
| 🧩 1 | Fundamentos | 5 | 3 |
| ⚙️ 2 | Configurações | 6 | 4 |
| 🌊 3 | Feedback visual | 5 | 1 |
| ☀️ 4 | Persistência e UX | 5 | 0 |
| **Total** | | **21** | **8** |

✅ **Progresso:** 8 de 21 tarefas concluídas  
_Atualize manualmente conforme marcar as caixas acima._

---

## 💡 Recursos Recomendados
- [Documentação Flutter](https://docs.flutter.dev/)
- [Widgets Catalog](https://docs.flutter.dev/ui/widgets)
- [SharedPreferences Package](https://pub.dev/packages/shared_preferences)
- [AnimatedContainer Widget](https://api.flutter.dev/flutter/widgets/AnimatedContainer-class.html)

---