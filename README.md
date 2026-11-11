# PataViva — Landing Page

Landing page profissional para pet shop e clínica veterinária, construída com **HTML5, CSS3, JavaScript e Bootstrap 5**, com identidade visual própria, conteúdo completo e foco em conversão.

> **Atenção:** os dados comerciais (nome, endereço, telefone, e-mail, CNPJ, CRMV, preços, avaliações e depoimentos) são fictícios e servem de modelo. Substitua pelas informações reais antes de publicar.

---

## Como visualizar

**Opção 1 — abrir direto (mais simples)**
Dê um duplo clique em `index.html`. O site funciona localmente (as imagens, fontes e o Bootstrap estão no projeto).

**Opção 2 — servidor local (recomendado)**
Dê um duplo clique em **`servir.bat`**. Ele abre o navegador em `http://localhost:8080` e serve o projeto com os tipos de arquivo corretos.

- Para encerrar: feche a janela preta ou pressione `Ctrl + C`.
- Se a porta 8080 estiver ocupada, o script tenta 8081, 8082... automaticamente.
- Para usar outra porta: `servir.bat -Port 3000` (ou `servidor.ps1 -Port 3000`).
- Sem abrir o navegador: `servidor.ps1 -NoBrowser`.

O servidor é feito em PowerShell (nativo do Windows), então **não precisa de Node.js nem Python**.

**Opção 3 — outros servidores**
Se preferir, qualquer servidor estático funciona:

```bash
# Python 3
python -m http.server 8080

# Node.js (npx)
npx serve .
```

Depois acesse `http://localhost:8080`.

---

## Estrutura do projeto

```
.
├── index.html                  # Página completa
├── servir.bat                  # Atalho: sobe o servidor local (duplo clique)
├── servidor.ps1                # Servidor estático em PowerShell
├── robots.txt                  # Diretivas para buscadores
├── sitemap.xml                 # Mapa do site
├── README.md
└── assets
    ├── css
    │   └── style.css           # Design system e componentes
    ├── js
    │   └── main.js             # Interações e validações
    ├── img                     # Fotos otimizadas + favicon
    ├── fonts                   # Plus Jakarta Sans + Fraunces (local)
    └── vendor
        ├── bootstrap           # Bootstrap 5.3.3 (local)
        └── bootstrap-icons     # Bootstrap Icons 1.11.3 (local)
```

Todos os recursos são **locais** — o site não depende de CDN para carregar.

---

## Seções da página

1. **Topbar** — endereço, horário, telefone, e-mail e redes sociais.
2. **Navbar sticky** — navegação com link ativo, menu mobile e CTA de agendamento.
3. **Hero** — proposta de valor, provas sociais, estatísticas animadas e cards flutuantes.
4. **Faixa de confiança** — CRMV, plantão 24h, táxi pet e produtos premium.
5. **Serviços** — 6 serviços com descrição, preço inicial e atalho para agendamento.
6. **Sobre** — história, diferenciais, números e selo de 12 anos.
7. **Como funciona** — jornada do atendimento em 4 passos.
8. **Planos** — Essencial, Completo e Premium, com benefícios e CTA via WhatsApp.
9. **Galeria** — 6 fotos com lightbox acessível.
10. **Depoimentos** — avaliação média, 6 depoimentos e selo de verificação.
11. **Equipe** — 3 profissionais com função, CRMV e especialidades.
12. **FAQ** — 8 dúvidas em accordion (também marcadas com schema `FAQPage`).
13. **CTA promocional** — oferta de 15% na primeira visita.
14. **Contato/Agendamento** — dados completos, horários, mapa e formulário validado.
15. **Rodapé** — newsletter, links, contato, formas de pagamento e modais de privacidade/termos.
16. **Extras** — WhatsApp flutuante, voltar ao topo e aviso de LGPD.

---

## Funcionalidades JavaScript

- Navbar com sombra ao rolar e link ativo por `IntersectionObserver`.
- Animações de entrada com respeito a `prefers-reduced-motion`.
- Contadores animados nas estatísticas.
- Galeria com modal (lightbox) e legendas.
- Pré-seleção do serviço ao clicar em “Agendar” em qualquer card.
- Máscara de telefone e data mínima igual a hoje.
- Validação de formulário com Bootstrap + mensagens em português.
- Envio do agendamento formatado direto para o **WhatsApp**.
- Newsletter com toast de confirmação.
- Aviso de LGPD com consentimento salvo em `localStorage`.
- Menu mobile que fecha automaticamente ao clicar em um link.
- Botão “voltar ao topo”.

---

## Personalização rápida

### Contatos e WhatsApp
Em `assets/js/main.js`, altere o bloco `CONFIG`:

```js
var CONFIG = {
  whatsapp: "5511987654321",   // somente números, com DDI + DDD
  phone: "+551134567890",
  phoneLabel: "(11) 3456-7890",
  email: "contato@pataviva.com.br",
  ...
};
```

Depois atualize também os links visíveis no HTML (`tel:`, `mailto:`, `wa.me`), o endereço, o CNPJ e os horários no `index.html`.

### Cores e tipografia
Os tokens ficam no início de `assets/css/style.css`:

```css
:root {
  --pv-brand-900: #0b3a30;
  --pv-brand-600: #177a63;
  --pv-accent: #ff8a4c;
  --pv-cream: #fbf8f2;
  ...
}
```

### Fotos
Substitua os arquivos em `assets/img/` mantendo os nomes, ou atualize os caminhos no HTML. Recomenda-se JPG/WebP com largura entre 800 px e 1600 px e compressão adequada.

### Planos e preços
Edite os valores nos cards da seção `#planos` e nos atributos `data-price`. O link de cada plano é gerado automaticamente pelo JavaScript.

### Formulário com backend
Hoje o envio abre o WhatsApp com a mensagem pronta. Para integrar com e-mail, CRM ou API, substitua o bloco de envio em `main.js` por um `fetch()` para o seu endpoint, mantendo a validação existente.

---

## SEO e compartilhamento

- Título, descrição, palavras-chave, canonical e Open Graph/Twitter Cards.
- **JSON-LD** com `PetStore` + `VeterinaryCare` (endereço, horários, geolocalização, avaliações e formas de pagamento).
- **JSON-LD** de `FAQPage` com as 8 perguntas.
- Estrutura semântica com um único `H1` e hierarquia de títulos correta.
- `robots.txt` e `sitemap.xml` incluídos.

**Antes de publicar:**
1. Troque `https://www.pataviva.com.br/` pelo domínio real no canonical, Open Graph, JSON-LD, `robots.txt` e `sitemap.xml`.
2. Use uma URL **absoluta** para `og:image` (a imagem precisa estar acessível publicamente).
3. Atualize o `lastmod` do sitemap.

---

## Acessibilidade e qualidade

Auditoria com Lighthouse (Chrome):

| Categoria | Pontuação |
|---|---|
| Acessibilidade | **100** |
| Boas práticas | **100** |
| SEO | **100** |

Também foram validados:

- Contraste de cores AA.
- Navegação por teclado e foco visível.
- `aria-label`, `aria-current`, `role="img"` e textos alternativos.
- Áreas de toque com no mínimo 24×24 px.
- Layout sem overflow horizontal de **360 px a 1440 px**.
- Respeito a `prefers-reduced-motion`.

---

## Deploy

O projeto é 100% estático. Basta publicar a pasta inteira em:

- **Netlify / Vercel:** arraste a pasta ou conecte o repositório.
- **GitHub Pages:** envie os arquivos para o repositório e ative o Pages.
- **Hospedagem tradicional:** copie o conteúdo para `public_html`.

Não é necessário build, npm ou variáveis de ambiente.

---

## Créditos

- **Bootstrap 5.3.3** e **Bootstrap Icons 1.11.3** — licença MIT.
- **Plus Jakarta Sans** e **Fraunces** — SIL Open Font License (Google Fonts).
- Fotografias — [Unsplash](https://unsplash.com) (licença Unsplash). Substitua por fotos reais do negócio quando possível.

---

Feito com carinho para pets e seus humanos. 🐾
