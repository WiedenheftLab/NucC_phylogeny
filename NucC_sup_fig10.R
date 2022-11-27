library("ape")
library("Biostrings")
library("ggplot2")
library("ggtree")
library('stringr')
library("ggnewscale")
library("tidyverse")
library("ggstance")

tree <- read.tree("tree_NucC_homologs_found_from_prodigal_and_blast_db_with_known_aligned_local.nexus")

tree.data <- as_tibble(tree)
treedata <- data.frame(slice(tree.data,1:1510))

p <- ggtree(tree,layout="equal_angle") + geom_treescale(x = -4,y = -2,width = 0.5,offset = -0.3,color = "black",linesize = 1,fontsize = 3.88,family = "sans")

p

quants <- list()

clade1 <- grep("EFJ98159.1",tree$tip.label)
clade2 <- grep("WP_141855040.1",tree$tip.label)
clade3 <- grep("WP_195923598.1",tree$tip.label)
clade4 <- grep("TEX45487.1",tree$tip.label)
clade5 <- grep("647193063",tree$tip.label)
clade6 <- grep("WP_003050273.1",tree$tip.label)

toMatch2 <- c("MBI4760404.1", "MBI5824582.1", "MBI4310973.1", "MBI4506439.1", "MBI2321998.1", "HAF11306.1","NC_010718.1_1528","NZ_LM995447.1_1163","NZ_LN879430.1_731","NC_011296.1_511","NZ_CP025197.1_1202","NZ_CP025197.1_2997","NZ_CP014673.1_2775")

thermophile <- unique (grep(paste(toMatch2,collapse="|"), 
                            tree$tip.label))

mesophile <- grep("EFJ98159.1|WP_141855040.1|WP_195923598.1|TEX45487.1|MBI4760404.1|MBI5824582.1|MBI4310973.1|MBI4506439.1|MBI2321998.1|HAF11306.1|647193063|WP_003050273.1NC_010718.1_1528|NZ_LM995447.1_1163|NZ_LN879430.1_731|NC_011296.1_511|NZ_CP025197.1_1202|NZ_CP025197.1_2997|NZ_CP014673.1_2775",tree$tip.label,invert = TRUE)

quants[["Mesophile"]] <- mesophile
quants[["Thermophiles"]] <- thermophile
quants[["EcNucC"]] <- clade1
quants[["EsNucC"]] <- clade2
quants[["CtNucC"]] <- clade3
quants[["AmtbNucC"]] <- clade4
quants[["VmNucC"]] <- clade5
quants[["PaNucC"]] <- clade6

p1 <- groupOTU(p, quants, 'Clade') + aes(color=Clade)
p1
