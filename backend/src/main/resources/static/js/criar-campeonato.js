// Mapeia o texto da tela para o valor aceito pelo banco
const STATUS_BANCO = {
  'Inscrições Abertas': 'PLANEJADO',
  'Em Andamento': 'EM_ANDAMENTO',
  'Encerrado': 'ENCERRADO'
};

document.querySelector('form').addEventListener('submit', async (e) => {
  e.preventDefault(); // impede a página de recarregar

  const modalidade = document.getElementById('modalidade').value;
  if (modalidade === 'Selecione') {
    alert('Escolha uma modalidade.');
    return;
  }

  const dados = {
    nome: document.getElementById('nome').value,
    modalidade: modalidade,
    dataInicio: document.getElementById('dataInicio').value,
    dataFim: document.getElementById('dataFim').value,
    maxEquipes: Number(document.getElementById('equipes').value),
    status: STATUS_BANCO[document.getElementById('status').value]
  };

  try {
    const resposta = await fetch('/api/v1/campeonatos', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(dados)
    });

    if (!resposta.ok) {
      alert('Não foi possível criar. Confira os campos (datas, limite de equipes, etc.).');
      return;
    }

    alert('Campeonato criado com sucesso!');
    window.location.href = 'campeonatos.html';
  } catch (erro) {
    alert('Erro de conexão com o servidor.');
  }
});