
clear
addpath('/home/durhael1/matlab_libraries/gifti-master')
ProjectFolder = '/labs/h_kaczkurkin_lab/ABCD_Bifactor_Vol/figures/CortexVisualize';
CorticalGen_Sig = csvread([ProjectFolder '/DesikanGenSig_tscores_headers.csv'], 1);

% Create file for surface
[~, VertexLabel_lh, Name_lh] = read_annotation('/accre/arch/easybuild/software/BinDist/FreeSurfer/6.0.0/subjects/fsaverage/label/lh.aparc.annot');
[~, VertexLabel_rh, Name_rh] = read_annotation('/accre/arch/easybuild/software/BinDist/FreeSurfer/6.0.0/subjects/fsaverage/label/rh.aparc.annot');
CorticalGen_Sig = csvread([ProjectFolder '/DesikanGenSig_tscores_headers.csv'], 1);
ind_lh = find(CorticalGen_Sig(:, 1) < 2000);
CorticalGen_Sig_lh = CorticalGen_Sig(ind_lh, :);
ind_rh = find(CorticalGen_Sig(:, 1) > 2000);
CorticalGen_Sig_rh = CorticalGen_Sig(ind_rh, :);
% lh
Vertex_AllLabel_InAtlas_lh = Name_lh.table(2:end, 5);
VertexStatistical_lh = zeros(size(VertexLabel_lh));
Sig_ID = CorticalGen_Sig_lh(:, 1);
for i = 1:length(Sig_ID)
  Vertex_LabelID = Vertex_AllLabel_InAtlas_lh(Sig_ID(i) - 1000);
  VertexIndex = find(VertexLabel_lh == Vertex_LabelID);
  VertexStatistical_lh(VertexIndex) = CorticalGen_Sig_lh(i, 2);
end
V_lh = gifti;
V_lh.cdata = VertexStatistical_lh;
V_lh_File = [ProjectFolder '/CortGen_lh_header.func.gii'];
save(V_lh, V_lh_File);
% rh
Vertex_AllLabel_InAtlas_rh = Name_rh.table(2:end, 5);
VertexStatistical_rh = zeros(size(VertexLabel_rh));
Sig_ID = CorticalGen_Sig_rh(:, 1);
for i = 1:length(Sig_ID)
  Vertex_LabelID = Vertex_AllLabel_InAtlas_rh(Sig_ID(i) - 2000);
  VertexIndex = find(VertexLabel_rh == Vertex_LabelID);
  VertexStatistical_rh(VertexIndex) = CorticalGen_Sig_rh(i, 2);
end
V_rh = gifti;
V_rh.cdata = VertexStatistical_rh;
V_rh_File = [ProjectFolder '/CortGen_rh_header.func.gii'];
save(V_rh, V_rh_File);

