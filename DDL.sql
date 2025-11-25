-- -------------------------------------------------
-- ESSE ARQUIVO FOI CRIADO COPIANDO AS INSTRUÇÕES --
--  SQL GERADAS POR TODAS AS MIGRAÇÕES DO PRISMA  --
-- -------------------------------------------------

-- CreateEnum
CREATE TYPE "public"."StatusPedido" AS ENUM ('CANCELADO', 'AGUARDANDO_PAGAMENTO', 'PENDENTE', 'EM_PREPARO', 'PRONTO_PARA_ENTREGA', 'PRONTO_PARA_RETIRADA', 'EM_ENTREGA', 'REALIZADO');

-- CreateTable
CREATE TABLE "public"."telefone" (
    "idTelefone" SERIAL NOT NULL,
    "ddd" VARCHAR(2) NOT NULL,
    "numero" VARCHAR(9) NOT NULL,
    "usuarioId" INTEGER,
    "lojaId" INTEGER,

    CONSTRAINT "telefone_pkey" PRIMARY KEY ("idTelefone")
);

-- CreateTable
CREATE TABLE "public"."endereco" (
    "idEndereco" SERIAL NOT NULL,
    "cep" VARCHAR(9) NOT NULL,
    "estado" TEXT NOT NULL,
    "cidade" TEXT NOT NULL,
    "bairro" TEXT NOT NULL,
    "rua" TEXT NOT NULL,
    "casa" VARCHAR(10) NOT NULL,
    "complemento" TEXT,

    CONSTRAINT "endereco_pkey" PRIMARY KEY ("idEndereco")
);

-- CreateTable
CREATE TABLE "public"."loja" (
    "idLoja" SERIAL NOT NULL,
    "nomeLoja" TEXT NOT NULL,
    "cnpj" VARCHAR(14) NOT NULL,
    "enderecoId" INTEGER NOT NULL,
    "latitude" DECIMAL(9,6) NOT NULL,
    "longitude" DECIMAL(9,6) NOT NULL,
    "horarioFuncionamento" TEXT NOT NULL,
    "ofereceDelivery" BOOLEAN NOT NULL,
    "raioEntregaKm" DECIMAL(65,30),

    CONSTRAINT "loja_pkey" PRIMARY KEY ("idLoja")
);

-- CreateTable
CREATE TABLE "public"."usuario" (
    "idUsuario" SERIAL NOT NULL,
    "nomeUsuario" VARCHAR(50) NOT NULL,
    "email" VARCHAR(30) NOT NULL,
    "senha" TEXT NOT NULL,
    "isFuncionario" BOOLEAN NOT NULL,
    "isAdmin" BOOLEAN NOT NULL,
    "enderecoId" INTEGER,
    "funcionarioLojaId" INTEGER,

    CONSTRAINT "usuario_pkey" PRIMARY KEY ("idUsuario")
);

-- CreateTable
CREATE TABLE "public"."relatorioUsuario" (
    "usuarioId" INTEGER NOT NULL,
    "gastosTotais" DECIMAL(10,2) NOT NULL,
    "gastosMensais" DECIMAL(10,2) NOT NULL,
    "qtdTotalPedidos" INTEGER NOT NULL,
    "qtdMensalPedidos" INTEGER NOT NULL,

    CONSTRAINT "relatorioUsuario_pkey" PRIMARY KEY ("usuarioId")
);

-- CreateTable
CREATE TABLE "public"."cupomDesconto" (
    "idCupomDesconto" SERIAL NOT NULL,
    "codCupom" TEXT NOT NULL,
    "validade" TIMESTAMP(3) NOT NULL,
    "qtdUsos" INTEGER NOT NULL,
    "usuarioId" INTEGER,

    CONSTRAINT "cupomDesconto_pkey" PRIMARY KEY ("idCupomDesconto")
);

-- CreateTable
CREATE TABLE "public"."categoriaProduto" (
    "idCategoria" SERIAL NOT NULL,
    "nomeCategoria" TEXT NOT NULL,
    "descricaoCategoria" TEXT NOT NULL,

    CONSTRAINT "categoriaProduto_pkey" PRIMARY KEY ("idCategoria")
);

-- CreateTable
CREATE TABLE "public"."produto" (
    "idProduto" SERIAL NOT NULL,
    "imagemUrl" TEXT NOT NULL,
    "nomeProduto" TEXT NOT NULL,
    "descricaoProduto" TEXT NOT NULL,
    "categoriaId" INTEGER NOT NULL,

    CONSTRAINT "produto_pkey" PRIMARY KEY ("idProduto")
);

-- CreateTable
CREATE TABLE "public"."produtosEmLoja " (
    "lojaId" INTEGER NOT NULL,
    "produtoId" INTEGER NOT NULL,
    "disponivel" BOOLEAN NOT NULL,
    "valorBase" DECIMAL(5,2) NOT NULL,
    "emPromocao" BOOLEAN NOT NULL,
    "descontoPromocao" INTEGER NOT NULL,
    "validadePromocao" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "produtosEmLoja _pkey" PRIMARY KEY ("lojaId","produtoId")
);

-- CreateTable
CREATE TABLE "public"."personalizavel" (
    "idPersonalizavel" SERIAL NOT NULL,
    "nomePersonalizavel" TEXT NOT NULL,
    "produtoId" INTEGER NOT NULL,
    "selecaoMinima" INTEGER NOT NULL,
    "selecaoMaxima" INTEGER NOT NULL,

    CONSTRAINT "personalizavel_pkey" PRIMARY KEY ("idPersonalizavel")
);

-- CreateTable
CREATE TABLE "public"."modificador" (
    "idModificador" SERIAL NOT NULL,
    "nomeModificador" TEXT NOT NULL,
    "personalizavelId" INTEGER NOT NULL,

    CONSTRAINT "modificador_pkey" PRIMARY KEY ("idModificador")
);

-- CreateTable
CREATE TABLE "public"."modificadorEmLoja" (
    "lojaId" INTEGER NOT NULL,
    "modificadorId" INTEGER NOT NULL,
    "disponivel" BOOLEAN NOT NULL,
    "valorAdicional" DECIMAL(4,2) NOT NULL,

    CONSTRAINT "modificadorEmLoja_pkey" PRIMARY KEY ("lojaId","modificadorId")
);

-- CreateTable
CREATE TABLE "public"."pedido" (
    "idPedido" SERIAL NOT NULL,
    "clienteId" INTEGER NOT NULL,
    "lojaId" INTEGER NOT NULL,
    "dataHoraPedido" TIMESTAMP(3) NOT NULL,
    "valorBase" DECIMAL(7,2) NOT NULL,
    "valorCobrado" DECIMAL(7,2) NOT NULL,
    "cupomUsadoId" INTEGER,
    "observacoesPedido" TEXT,
    "status" "public"."StatusPedido" NOT NULL,

    CONSTRAINT "pedido_pkey" PRIMARY KEY ("idPedido")
);

-- CreateTable
CREATE TABLE "public"."itemPedido" (
    "pedidoId" INTEGER NOT NULL,
    "produtoId" INTEGER NOT NULL,
    "qtdProduto" INTEGER NOT NULL,
    "valorTotalProdutos" DECIMAL(7,2) NOT NULL,

    CONSTRAINT "itemPedido_pkey" PRIMARY KEY ("pedidoId","produtoId")
);

-- CreateIndex
CREATE UNIQUE INDEX "telefone_ddd_numero_key" ON "public"."telefone"("ddd", "numero");

-- CreateIndex
CREATE UNIQUE INDEX "loja_nomeLoja_key" ON "public"."loja"("nomeLoja");

-- CreateIndex
CREATE UNIQUE INDEX "loja_cnpj_key" ON "public"."loja"("cnpj");

-- CreateIndex
CREATE UNIQUE INDEX "loja_enderecoId_key" ON "public"."loja"("enderecoId");

-- CreateIndex
CREATE UNIQUE INDEX "usuario_email_key" ON "public"."usuario"("email");

-- CreateIndex
CREATE UNIQUE INDEX "usuario_enderecoId_key" ON "public"."usuario"("enderecoId");

-- CreateIndex
CREATE UNIQUE INDEX "cupomDesconto_codCupom_key" ON "public"."cupomDesconto"("codCupom");

-- AddForeignKey
ALTER TABLE "public"."telefone" ADD CONSTRAINT "telefone_usuario_fk" FOREIGN KEY ("usuarioId") REFERENCES "public"."usuario"("idUsuario") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."telefone" ADD CONSTRAINT "telefone_loja_fk" FOREIGN KEY ("lojaId") REFERENCES "public"."loja"("idLoja") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."loja" ADD CONSTRAINT "loja_endereco_fk" FOREIGN KEY ("enderecoId") REFERENCES "public"."endereco"("idEndereco") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."usuario" ADD CONSTRAINT "usuario_endereco_fk" FOREIGN KEY ("enderecoId") REFERENCES "public"."endereco"("idEndereco") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."usuario" ADD CONSTRAINT "usuario_loja_fk" FOREIGN KEY ("funcionarioLojaId") REFERENCES "public"."loja"("idLoja") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."relatorioUsuario" ADD CONSTRAINT "relatorio_usuario_fk" FOREIGN KEY ("usuarioId") REFERENCES "public"."usuario"("idUsuario") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."cupomDesconto" ADD CONSTRAINT "cupom_usuario_fk" FOREIGN KEY ("usuarioId") REFERENCES "public"."usuario"("idUsuario") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."produto" ADD CONSTRAINT "produto_categoria_fk" FOREIGN KEY ("categoriaId") REFERENCES "public"."categoriaProduto"("idCategoria") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."produtosEmLoja " ADD CONSTRAINT "lojaProduto_loja_fk" FOREIGN KEY ("lojaId") REFERENCES "public"."loja"("idLoja") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."produtosEmLoja " ADD CONSTRAINT "lojaProduto_produto_fk" FOREIGN KEY ("produtoId") REFERENCES "public"."produto"("idProduto") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."personalizavel" ADD CONSTRAINT "personalizavel_produto_fk" FOREIGN KEY ("produtoId") REFERENCES "public"."produto"("idProduto") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."modificador" ADD CONSTRAINT "modificador_personalizavel_fk" FOREIGN KEY ("personalizavelId") REFERENCES "public"."personalizavel"("idPersonalizavel") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."modificadorEmLoja" ADD CONSTRAINT "lojaMod_loja_fk" FOREIGN KEY ("lojaId") REFERENCES "public"."loja"("idLoja") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."modificadorEmLoja" ADD CONSTRAINT "lojaMod_modificador_fk" FOREIGN KEY ("modificadorId") REFERENCES "public"."modificador"("idModificador") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."pedido" ADD CONSTRAINT "pedido_usuario_fk" FOREIGN KEY ("clienteId") REFERENCES "public"."usuario"("idUsuario") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."pedido" ADD CONSTRAINT "pedido_loja_fk" FOREIGN KEY ("lojaId") REFERENCES "public"."loja"("idLoja") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itemPedido" ADD CONSTRAINT "itemPedido_pedido_fk" FOREIGN KEY ("pedidoId") REFERENCES "public"."pedido"("idPedido") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itemPedido" ADD CONSTRAINT "itemPedido_produto_fk" FOREIGN KEY ("produtoId") REFERENCES "public"."produto"("idProduto") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AlterTable
ALTER TABLE "public"."endereco" ADD COLUMN     "latitude" DECIMAL(9,6) NOT NULL,
ADD COLUMN     "longitude" DECIMAL(9,6) NOT NULL,
ADD COLUMN     "pontoReferencia" TEXT NOT NULL;

-- AlterTable
ALTER TABLE "public"."loja" DROP COLUMN "latitude",
DROP COLUMN "longitude";

-- AlterTable
ALTER TABLE "public"."pedido" ADD COLUMN     "paraEntrega" BOOLEAN NOT NULL;

-- AlterTable
ALTER TABLE "public"."usuario" ADD COLUMN     "resetPasswordToken" TEXT,
ADD COLUMN     "resetPasswordTokenExpires" TIMESTAMP(3);

-- CreateTable
CREATE TABLE "public"."carrinho" (
    "idCarrinho" INTEGER NOT NULL,
    "paraEntrega" BOOLEAN NOT NULL,
    "valorBase" DECIMAL(7,2) NOT NULL,

    CONSTRAINT "carrinho_pkey" PRIMARY KEY ("idCarrinho")
);

-- CreateTable
CREATE TABLE "public"."itemCarrinho" (
    "carrinhoId" INTEGER NOT NULL,
    "produtoId" INTEGER NOT NULL,
    "qtdProduto" INTEGER NOT NULL,
    "valorTotalProdutos" DECIMAL(7,2) NOT NULL,

    CONSTRAINT "itemCarrinho_pkey" PRIMARY KEY ("carrinhoId","produtoId")
);

-- CreateIndex
CREATE UNIQUE INDEX "categoriaProduto_nomeCategoria_key" ON "public"."categoriaProduto"("nomeCategoria");

-- CreateIndex
CREATE UNIQUE INDEX "usuario_resetPasswordToken_key" ON "public"."usuario"("resetPasswordToken");

-- AddForeignKey
ALTER TABLE "public"."carrinho" ADD CONSTRAINT "carrinho_usuario_fk" FOREIGN KEY ("idCarrinho") REFERENCES "public"."usuario"("idUsuario") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itemCarrinho" ADD CONSTRAINT "itemCarrinho_carrinho_fk" FOREIGN KEY ("carrinhoId") REFERENCES "public"."carrinho"("idCarrinho") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itemCarrinho" ADD CONSTRAINT "itemCarrinho_produto_fk" FOREIGN KEY ("produtoId") REFERENCES "public"."produto"("idProduto") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AlterTable
ALTER TABLE "public"."carrinho" ADD COLUMN     "atualizadoEm" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "public"."categoriaProduto" ADD COLUMN     "atualizadoEm" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "public"."cupomDesconto" ADD COLUMN     "atualizadoEm" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "public"."endereco" ADD COLUMN     "atualizadoEm" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "public"."itemCarrinho" ADD COLUMN     "atualizadoEm" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "public"."itemPedido" ADD COLUMN     "atualizadoEm" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "public"."loja" ADD COLUMN     "atualizadoEm" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "public"."modificador" ADD COLUMN     "atualizadoEm" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "public"."modificadorEmLoja" ADD COLUMN     "atualizadoEm" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "public"."pedido" ADD COLUMN     "atualizadoEm" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "public"."personalizavel" ADD COLUMN     "atualizadoEm" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "public"."produto" ADD COLUMN     "atualizadoEm" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "public"."produtosEmLoja " ADD COLUMN     "atualizadoEm" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "public"."relatorioUsuario" ADD COLUMN     "atualizadoEm" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "public"."telefone" ADD COLUMN     "atualizadoEm" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "public"."usuario" ADD COLUMN     "atualizadoEm" TIMESTAMP(3) NOT NULL,
ADD COLUMN     "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP;

-- AlterTable
ALTER TABLE "public"."endereco" DROP COLUMN "casa",
DROP COLUMN "rua",
ADD COLUMN     "logradouro" TEXT NOT NULL,
ADD COLUMN     "numero" VARCHAR(10) NOT NULL;

-- AlterTable
ALTER TABLE "public"."cupomDesconto" ADD COLUMN     "ativo" BOOLEAN NOT NULL DEFAULT true;

-- AddForeignKey
ALTER TABLE "public"."pedido" ADD CONSTRAINT "pedido_cupom_fk" FOREIGN KEY ("cupomUsadoId") REFERENCES "public"."cupomDesconto"("idCupomDesconto") ON DELETE SET NULL ON UPDATE CASCADE;

-- AlterTable
ALTER TABLE "public"."usuario" ADD COLUMN     "changeEmailToken" TEXT,
ADD COLUMN     "changeEmailTokenExpires" TIMESTAMP(3),
ADD COLUMN     "newEmailPendingVerification" TEXT;

-- CreateIndex
CREATE UNIQUE INDEX "usuario_changeEmailToken_key" ON "public"."usuario"("changeEmailToken");

-- AlterTable
ALTER TABLE "public"."usuario" ADD COLUMN     "emailVerificationToken" TEXT,
ADD COLUMN     "emailVerificationTokenExpires" TIMESTAMP(3),
ADD COLUMN     "emailVerifiedAt" TIMESTAMP(3),
ADD COLUMN     "isEmailVerified" BOOLEAN NOT NULL DEFAULT false;

-- CreateIndex
CREATE UNIQUE INDEX "usuario_emailVerificationToken_key" ON "public"."usuario"("emailVerificationToken");

-- DropForeignKey
ALTER TABLE "public"."carrinho" DROP CONSTRAINT "carrinho_usuario_fk";

-- DropForeignKey
ALTER TABLE "public"."cupomDesconto" DROP CONSTRAINT "cupom_usuario_fk";

-- DropForeignKey
ALTER TABLE "public"."itemCarrinho" DROP CONSTRAINT "itemCarrinho_carrinho_fk";

-- DropForeignKey
ALTER TABLE "public"."pedido" DROP CONSTRAINT "pedido_usuario_fk";

-- DropForeignKey
ALTER TABLE "public"."relatorioUsuario" DROP CONSTRAINT "relatorio_usuario_fk";

-- DropForeignKey
ALTER TABLE "public"."telefone" DROP CONSTRAINT "telefone_usuario_fk";

-- DropIndex
DROP INDEX "public"."usuario_changeEmailToken_key";

-- DropIndex
DROP INDEX "public"."usuario_emailVerificationToken_key";

-- DropIndex
DROP INDEX "public"."usuario_resetPasswordToken_key";

-- AlterTable
ALTER TABLE "public"."carrinho" DROP CONSTRAINT "carrinho_pkey",
ALTER COLUMN "idCarrinho" SET DATA TYPE TEXT,
ADD CONSTRAINT "carrinho_pkey" PRIMARY KEY ("idCarrinho");

-- AlterTable
ALTER TABLE "public"."cupomDesconto" ALTER COLUMN "usuarioId" SET DATA TYPE TEXT;

-- AlterTable
ALTER TABLE "public"."itemCarrinho" DROP CONSTRAINT "itemCarrinho_pkey",
ALTER COLUMN "carrinhoId" SET DATA TYPE TEXT,
ADD CONSTRAINT "itemCarrinho_pkey" PRIMARY KEY ("carrinhoId", "produtoId");

-- AlterTable
ALTER TABLE "public"."pedido" ALTER COLUMN "clienteId" SET DATA TYPE TEXT;

-- AlterTable
ALTER TABLE "public"."relatorioUsuario" DROP CONSTRAINT "relatorioUsuario_pkey",
ALTER COLUMN "usuarioId" SET DATA TYPE TEXT,
ADD CONSTRAINT "relatorioUsuario_pkey" PRIMARY KEY ("usuarioId");

-- AlterTable
ALTER TABLE "public"."telefone" ALTER COLUMN "usuarioId" SET DATA TYPE TEXT;

-- AlterTable
ALTER TABLE "public"."usuario" DROP CONSTRAINT "usuario_pkey",
DROP COLUMN "changeEmailToken",
DROP COLUMN "changeEmailTokenExpires",
DROP COLUMN "emailVerificationToken",
DROP COLUMN "emailVerificationTokenExpires",
DROP COLUMN "emailVerifiedAt",
DROP COLUMN "isEmailVerified",
DROP COLUMN "newEmailPendingVerification",
DROP COLUMN "resetPasswordToken",
DROP COLUMN "resetPasswordTokenExpires",
DROP COLUMN "senha",
ALTER COLUMN "idUsuario" DROP DEFAULT,
ALTER COLUMN "idUsuario" SET DATA TYPE TEXT,
ADD CONSTRAINT "usuario_pkey" PRIMARY KEY ("idUsuario");
DROP SEQUENCE "usuario_idUsuario_seq";

-- AddForeignKey
ALTER TABLE "public"."telefone" ADD CONSTRAINT "telefone_usuario_fk" FOREIGN KEY ("usuarioId") REFERENCES "public"."usuario"("idUsuario") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."relatorioUsuario" ADD CONSTRAINT "relatorio_usuario_fk" FOREIGN KEY ("usuarioId") REFERENCES "public"."usuario"("idUsuario") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."cupomDesconto" ADD CONSTRAINT "cupom_usuario_fk" FOREIGN KEY ("usuarioId") REFERENCES "public"."usuario"("idUsuario") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."pedido" ADD CONSTRAINT "pedido_usuario_fk" FOREIGN KEY ("clienteId") REFERENCES "public"."usuario"("idUsuario") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."carrinho" ADD CONSTRAINT "carrinho_usuario_fk" FOREIGN KEY ("idCarrinho") REFERENCES "public"."usuario"("idUsuario") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itemCarrinho" ADD CONSTRAINT "itemCarrinho_carrinho_fk" FOREIGN KEY ("carrinhoId") REFERENCES "public"."carrinho"("idCarrinho") ON DELETE RESTRICT ON UPDATE CASCADE;

-- DropForeignKey
ALTER TABLE "public"."carrinho" DROP CONSTRAINT "carrinho_usuario_fk";

-- DropForeignKey
ALTER TABLE "public"."itemCarrinho" DROP CONSTRAINT "itemCarrinho_carrinho_fk";

-- DropForeignKey
ALTER TABLE "public"."itemCarrinho" DROP CONSTRAINT "itemCarrinho_produto_fk";

-- DropForeignKey
ALTER TABLE "public"."itemPedido" DROP CONSTRAINT "itemPedido_pedido_fk";

-- DropForeignKey
ALTER TABLE "public"."modificador" DROP CONSTRAINT "modificador_personalizavel_fk";

-- DropForeignKey
ALTER TABLE "public"."modificadorEmLoja" DROP CONSTRAINT "lojaMod_loja_fk";

-- DropForeignKey
ALTER TABLE "public"."modificadorEmLoja" DROP CONSTRAINT "lojaMod_modificador_fk";

-- DropForeignKey
ALTER TABLE "public"."pedido" DROP CONSTRAINT "pedido_usuario_fk";

-- DropForeignKey
ALTER TABLE "public"."personalizavel" DROP CONSTRAINT "personalizavel_produto_fk";

-- DropForeignKey
ALTER TABLE "public"."produtosEmLoja " DROP CONSTRAINT "lojaProduto_loja_fk";

-- DropForeignKey
ALTER TABLE "public"."produtosEmLoja " DROP CONSTRAINT "lojaProduto_produto_fk";

-- DropForeignKey
ALTER TABLE "public"."relatorioUsuario" DROP CONSTRAINT "relatorio_usuario_fk";

-- DropForeignKey
ALTER TABLE "public"."telefone" DROP CONSTRAINT "telefone_loja_fk";

-- DropForeignKey
ALTER TABLE "public"."telefone" DROP CONSTRAINT "telefone_usuario_fk";

-- AlterTable
ALTER TABLE "public"."pedido" ALTER COLUMN "clienteId" DROP NOT NULL;

-- AddForeignKey
ALTER TABLE "public"."telefone" ADD CONSTRAINT "telefone_usuario_fk" FOREIGN KEY ("usuarioId") REFERENCES "public"."usuario"("idUsuario") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."telefone" ADD CONSTRAINT "telefone_loja_fk" FOREIGN KEY ("lojaId") REFERENCES "public"."loja"("idLoja") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."relatorioUsuario" ADD CONSTRAINT "relatorio_usuario_fk" FOREIGN KEY ("usuarioId") REFERENCES "public"."usuario"("idUsuario") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."produtosEmLoja " ADD CONSTRAINT "lojaProduto_loja_fk" FOREIGN KEY ("lojaId") REFERENCES "public"."loja"("idLoja") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."produtosEmLoja " ADD CONSTRAINT "lojaProduto_produto_fk" FOREIGN KEY ("produtoId") REFERENCES "public"."produto"("idProduto") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."personalizavel" ADD CONSTRAINT "personalizavel_produto_fk" FOREIGN KEY ("produtoId") REFERENCES "public"."produto"("idProduto") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."modificador" ADD CONSTRAINT "modificador_personalizavel_fk" FOREIGN KEY ("personalizavelId") REFERENCES "public"."personalizavel"("idPersonalizavel") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."modificadorEmLoja" ADD CONSTRAINT "lojaMod_loja_fk" FOREIGN KEY ("lojaId") REFERENCES "public"."loja"("idLoja") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."modificadorEmLoja" ADD CONSTRAINT "lojaMod_modificador_fk" FOREIGN KEY ("modificadorId") REFERENCES "public"."modificador"("idModificador") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."pedido" ADD CONSTRAINT "pedido_usuario_fk" FOREIGN KEY ("clienteId") REFERENCES "public"."usuario"("idUsuario") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itemPedido" ADD CONSTRAINT "itemPedido_pedido_fk" FOREIGN KEY ("pedidoId") REFERENCES "public"."pedido"("idPedido") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."carrinho" ADD CONSTRAINT "carrinho_usuario_fk" FOREIGN KEY ("idCarrinho") REFERENCES "public"."usuario"("idUsuario") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itemCarrinho" ADD CONSTRAINT "itemCarrinho_carrinho_fk" FOREIGN KEY ("carrinhoId") REFERENCES "public"."carrinho"("idCarrinho") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itemCarrinho" ADD CONSTRAINT "itemCarrinho_produto_fk" FOREIGN KEY ("produtoId") REFERENCES "public"."produto"("idProduto") ON DELETE CASCADE ON UPDATE CASCADE;

-- CreateEnum
CREATE TYPE "public"."EstadosBrasil" AS ENUM ('AC', 'AL', 'AP', 'AM', 'BA', 'CE', 'DF', 'ES', 'GO', 'MA', 'MT', 'MS', 'MG', 'PA', 'PB', 'PR', 'PE', 'PI', 'RJ', 'RN', 'RS', 'RO', 'RR', 'SC', 'SP', 'SE', 'TO');

-- AlterTable
ALTER TABLE "public"."endereco" DROP COLUMN "estado",
ADD COLUMN     "estado" "public"."EstadosBrasil" NOT NULL,
ALTER COLUMN "pontoReferencia" DROP NOT NULL;

-- CreateEnum
CREATE TYPE "public"."RoleUsuario" AS ENUM ('CLIENTE', 'FUNCIONARIO', 'ADMIN');

-- CreateEnum
CREATE TYPE "public"."TipoPedido" AS ENUM ('ENTREGA', 'RETIRADA');

-- AlterTable
ALTER TABLE "public"."carrinho" DROP COLUMN "paraEntrega",
ADD COLUMN     "tipoPedido" "public"."TipoPedido" NOT NULL;

-- AlterTable
ALTER TABLE "public"."pedido" DROP COLUMN "paraEntrega",
ADD COLUMN     "tipoPedido" "public"."TipoPedido" NOT NULL;

-- AlterTable
ALTER TABLE "public"."usuario" DROP COLUMN "isAdmin",
DROP COLUMN "isFuncionario",
ADD COLUMN     "cargo" "public"."RoleUsuario" NOT NULL DEFAULT 'CLIENTE';

-- AlterTable
ALTER TABLE "public"."relatorioUsuario" ADD COLUMN     "dataUltimoPedido" TIMESTAMP(3),
ADD COLUMN     "gastoDesdeUltimoCupom" DECIMAL(10,2) NOT NULL DEFAULT 0.0;

-- CreateEnum
CREATE TYPE "public"."TipoDesconto" AS ENUM ('PERCENTUAL', 'VALOR_FIXO');

-- AlterTable
ALTER TABLE "public"."cupomDesconto" ADD COLUMN     "tipoDesconto" "public"."TipoDesconto" NOT NULL,
ADD COLUMN     "valorDesconto" DECIMAL(10,2) NOT NULL,
ALTER COLUMN "qtdUsos" DROP NOT NULL;

-- AlterTable
ALTER TABLE "public"."modificador" ADD COLUMN     "descricaoModificador" TEXT,
ADD COLUMN     "isOpcaoPadrao" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "ordemVisualizacao" INTEGER;

-- AlterTable
ALTER TABLE "public"."produtosEmLoja " ALTER COLUMN "descontoPromocao" DROP NOT NULL,
ALTER COLUMN "validadePromocao" DROP NOT NULL;

-- AlterTable
ALTER TABLE "public"."carrinho" ALTER COLUMN "valorBase" SET DEFAULT 0.0;

-- AlterTable
ALTER TABLE "public"."categoriaProduto" ALTER COLUMN "descricaoCategoria" DROP NOT NULL;

-- AlterTable
ALTER TABLE "public"."endereco" ALTER COLUMN "latitude" DROP NOT NULL,
ALTER COLUMN "longitude" DROP NOT NULL;

-- AlterTable
ALTER TABLE "public"."itemCarrinho" ALTER COLUMN "valorTotalProdutos" SET DEFAULT 0.0;

-- AlterTable
ALTER TABLE "public"."pedido" ALTER COLUMN "dataHoraPedido" SET DEFAULT CURRENT_TIMESTAMP,
ALTER COLUMN "status" SET DEFAULT 'PENDENTE';

-- AlterTable
ALTER TABLE "public"."produto" ALTER COLUMN "imagemUrl" DROP NOT NULL,
ALTER COLUMN "descricaoProduto" DROP NOT NULL;

-- AlterTable
ALTER TABLE "public"."relatorioUsuario" ALTER COLUMN "gastosTotais" SET DEFAULT 0.0,
ALTER COLUMN "gastosMensais" SET DEFAULT 0.0,
ALTER COLUMN "qtdTotalPedidos" SET DEFAULT 0,
ALTER COLUMN "qtdMensalPedidos" SET DEFAULT 0;

-- DropForeignKey
ALTER TABLE "public"."itemCarrinho" DROP CONSTRAINT "itemCarrinho_produto_fk";

-- AlterTable
ALTER TABLE "public"."carrinho" DROP COLUMN "valorBase",
ADD COLUMN     "lojaId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "public"."itemCarrinho" DROP CONSTRAINT "itemCarrinho_pkey",
DROP COLUMN "valorTotalProdutos",
ADD COLUMN     "id" SERIAL NOT NULL,
ADD COLUMN     "valorUnitarioProduto" DECIMAL(7,2) NOT NULL,
ALTER COLUMN "qtdProduto" SET DEFAULT 1,
ADD CONSTRAINT "itemCarrinho_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "public"."loja" ADD COLUMN     "carrinhoId" TEXT NOT NULL;

-- CreateTable
CREATE TABLE "public"."itemCarrinhoModificadores" (
    "itemCarrinhoId" INTEGER NOT NULL,
    "modificadorId" INTEGER NOT NULL,
    "valorAdicionalCobrado" DECIMAL(4,2) NOT NULL,

    CONSTRAINT "itemCarrinhoModificadores_pkey" PRIMARY KEY ("itemCarrinhoId","modificadorId")
);

-- AddForeignKey
ALTER TABLE "public"."carrinho" ADD CONSTRAINT "carrinho_loja_fk" FOREIGN KEY ("lojaId") REFERENCES "public"."loja"("idLoja") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itemCarrinho" ADD CONSTRAINT "itemCarrinho_produto_fk" FOREIGN KEY ("produtoId") REFERENCES "public"."produto"("idProduto") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itemCarrinhoModificadores" ADD CONSTRAINT "itemCarrinhoModificadores_modificadorId_fkey" FOREIGN KEY ("modificadorId") REFERENCES "public"."modificador"("idModificador") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itemCarrinhoModificadores" ADD CONSTRAINT "itemCarrinhoModificadores_itemCarrinhoId_fkey" FOREIGN KEY ("itemCarrinhoId") REFERENCES "public"."itemCarrinho"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AlterTable
ALTER TABLE "public"."itemPedido" DROP CONSTRAINT "itemPedido_pkey",
DROP COLUMN "valorTotalProdutos",
ADD COLUMN     "itemPedidoId" SERIAL NOT NULL,
ADD COLUMN     "valorUnitarioProduto" DECIMAL(7,2) NOT NULL,
ADD CONSTRAINT "itemPedido_pkey" PRIMARY KEY ("itemPedidoId");

-- CreateTable
CREATE TABLE "public"."itemPedidoModificadores" (
    "itemPedidoId" INTEGER NOT NULL,
    "modificadorId" INTEGER NOT NULL,
    "valorAdicionalCobrado" DECIMAL(4,2) NOT NULL,

    CONSTRAINT "itemPedidoModificadores_pkey" PRIMARY KEY ("itemPedidoId","modificadorId")
);

-- AddForeignKey
ALTER TABLE "public"."itemPedidoModificadores" ADD CONSTRAINT "itemPedidoModificadores_itemPedidoId_fkey" FOREIGN KEY ("itemPedidoId") REFERENCES "public"."itemPedido"("itemPedidoId") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."itemPedidoModificadores" ADD CONSTRAINT "itemPedidoModificadores_modificadorId_fkey" FOREIGN KEY ("modificadorId") REFERENCES "public"."modificador"("idModificador") ON DELETE RESTRICT ON UPDATE CASCADE;

-- CreateEnum
CREATE TYPE "public"."AuthTokenType" AS ENUM ('EMAIL_VERIFICATION', 'PASSWORD_RESET', 'EMAIL_UPDATE');

-- AlterTable
ALTER TABLE "public"."usuario" ADD COLUMN     "emailVerificado" BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN     "senha" TEXT NOT NULL;

-- CreateTable
CREATE TABLE "public"."authToken" (
    "id" TEXT NOT NULL,
    "token" TEXT NOT NULL,
    "tipo" "public"."AuthTokenType" NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "usado" BOOLEAN NOT NULL DEFAULT false,
    "payload" JSONB,
    "usuarioId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "authToken_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."authRefreshToken" (
    "id" TEXT NOT NULL,
    "selector" TEXT NOT NULL,
    "validatorHash" TEXT NOT NULL,
    "expiresAt" TIMESTAMP(3) NOT NULL,
    "revogado" BOOLEAN NOT NULL DEFAULT false,
    "usuarioId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "authRefreshToken_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "authToken_token_key" ON "public"."authToken"("token");

-- CreateIndex
CREATE UNIQUE INDEX "authRefreshToken_selector_key" ON "public"."authRefreshToken"("selector");

-- AddForeignKey
ALTER TABLE "public"."authToken" ADD CONSTRAINT "authToken_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "public"."usuario"("idUsuario") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."authRefreshToken" ADD CONSTRAINT "authRefreshToken_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "public"."usuario"("idUsuario") ON DELETE CASCADE ON UPDATE CASCADE;

-- AlterTable
ALTER TABLE "public"."loja" DROP COLUMN "carrinhoId";

-- AlterTable
ALTER TABLE "public"."pedido" ADD COLUMN     "enderecoEntregaId" INTEGER;

-- CreateIndex
CREATE UNIQUE INDEX "pedido_enderecoEntregaId_key" ON "public"."pedido"("enderecoEntregaId");

-- AddForeignKey
ALTER TABLE "public"."pedido" ADD CONSTRAINT "pedido_endereco_fk" FOREIGN KEY ("enderecoEntregaId") REFERENCES "public"."endereco"("idEndereco") ON DELETE RESTRICT ON UPDATE CASCADE;
