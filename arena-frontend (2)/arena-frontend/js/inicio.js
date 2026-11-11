import { exigirSessao, sair } from "./auth.js";

const sessao = exigirSessao();

if (sessao) {
  document.getElementById("usuario-nome").textContent = sessao.nome;
  document.getElementById("saudacao").textContent = sessao.nome.split(" ")[0];
  document.getElementById("botao-sair").addEventListener("click", sair);
}