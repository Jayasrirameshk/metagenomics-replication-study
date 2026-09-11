library(forcats)
library(ggplot2)


kaiju_all_samples[is.na(kaiju_all_samples)] = 0

kaiju_all_samples <- kaiju_all_samples %>%
  mutate(file = sub("\\.kaiju\\.out$", "", file))

kaiju_all_samples = kaiju_all_samples %>%
  group_by(file) %>%
  mutate(rel_abundance = (reads/sum(reads))) %>%
  ungroup()

kaiju_all_samples = kaiju_all_samples %>%
  mutate(taxon_name_lump = fct_lump(taxon_name, n = 15, w = rel_abundance, other_level = "others"))
         
kraken = kraken %>%
  mutate(name_lump = fct_lump(name, n = 15, w = relabundance, other_level = "others"))

metaphlan4_family = metaphlan4_family %>%
  mutate(name_lump = fct_lump(name,n = 15, w = relabundance, other_level = "others"))

kaiju_uniform <- kaiju_all_samples %>%
  rename(sampleID = file, taxon = taxon_name_lump, rel_abund = rel_abundance) %>%
  mutate(tool = "Kaiju")

metaphlan_uniform <- metaphlan4_family %>%
  rename(sampleID = sampleID, taxon = name_lump, rel_abund = relabundance) %>%
  mutate(tool = "MetaPhlAn")

kraken_uniform <- kraken %>%
  rename(sampleID = sampleID, taxon = name_lump, rel_abund = relabundance) %>%
  mutate(tool = "Kraken")

all_three = bind_rows(kaiju_uniform,kraken_uniform,metaphlan_uniform)
all_three$taxon = fct_lump(factor(all_three$taxon), n =15, w = all_three$rel_abund, other_level = "others")

plot_names = c("AE1235","AE1236","AE1237","AE1238","AE1239","AE1240","AE1241","AE1242","AE1243")
all_three$sampleID <- factor(all_three$sampleID, levels = unique(all_three$sampleID), labels = plot_names)

plot_colors = c("darkblue","darkgreen","red","yellow","darkorange", "violet","pink","purple","lightgreen","lightblue","black","cyan","brown","orchid","darkcyan","grey") 

ggplot(all_three, aes(x = tool, y = rel_abund, fill = taxon)) +
  geom_bar(stat = "identity") +
  scale_fill_manual(values = plot_colors, name = "Taxon") +
  labs(x = "Tool", y = "Relative Abundance") +
  theme_minimal(base_size = 5) +
  facet_wrap(~ sampleID, ncol = 1)  


