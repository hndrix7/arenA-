import { entrar } from "./auth.js";

const form = document.getElementById("form-login");
const campoUsuario = document.getElementById("usuario");
const campoSenha = document.getElementById("senha");
const alertaErro = document.getElementById("login-erro");

function marcarCampo(input, mensagem) {
  const grupo = input.closest(".campo");
  grupo.classList.toggle("campo--invalido", mensagem !== "");
  grupo.querySelector(".campo__erro").textContent = mensagem;
}

form.addEventListener("submit", (evento) => {
  evento.preventDefault(); 
  alertaErro.hidden = true;

  const usuario = campoUsuario.value.trim();
  const senha = campoSenha.value;

  marcarCampo(campoUsuario, usuario ? "" : "Informe seu usuário.");
  marcarCampo(campoSenha, senha ? "" : "Informe sua senha.");
  if (!usuario || !senha) return; 

  if (entrar(usuario, senha)) {
    location.href = "inicio.html";
  } else {
    alertaErro.hidden = false; 
  }
});