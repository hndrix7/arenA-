const CHAVE_SESSAO = "arena.sessao";

const USUARIOS_DEMO = [
  { usuario: "organizador", senha: "arena123", nome: "Carla Organizadora", perfil: "organizador" },
  { usuario: "diretor", senha: "arena123", nome: "Diego Diretor", perfil: "diretor" },
];

export function entrar(usuario, senha) {
  const conta = USUARIOS_DEMO.find((u) => u.usuario === usuario && u.senha === senha);
  if (!conta) return false;
  const sessao = { usuario: conta.usuario, nome: conta.nome, perfil: conta.perfil };
  sessionStorage.setItem(CHAVE_SESSAO, JSON.stringify(sessao));
  return true;
}
export function sessaoAtual() {
  try {
    return JSON.parse(sessionStorage.getItem(CHAVE_SESSAO));
  } catch {
    return null;
  }
}
export function sair() {
  sessionStorage.removeItem(CHAVE_SESSAO);
  location.replace("index.html");
}
export function exigirSessao() {
  const sessao = sessaoAtual();
  if (!sessao) location.replace("index.html");
  return sessao;
}