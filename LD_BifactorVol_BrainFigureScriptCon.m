
clear
addpath('/home/durhael1/matlab_libraries/gifti-master')
ProjectFolder = '/labs/h_kaczkurkin_lab/ABCD_Bifactor_Vol/figures/CortexVisualize';
CorticalCon_Sig = csvread([ProjectFolder '/DesikanConSig_zscores_header.csv'], 1);

% Create file for surface
[~, VertexLabel_lh, Name_lh] = read_annotation('/accre/arch/easybuild/software/BinDist/FreeSurfer/6.0.0/subjects/fsaverage/label/lh.aparc.annot');
[~, VertexLabel_rh, Name_rh] = read_annotation('/accre/arch/easybuild/software/BinDist/FreeSurfer/6.0.0/subjects/fsaverage/label/rh.aparc.annot');
CorticalCon_Sig = csvread([ProjectFolder '/DesikanConSig_zscores_header.csv'], 1);
ind_lh = find(CorticalCon_Sig(:, 1) < 2000);
CorticalCon_Sig_lh = CorticalCon_Sig(ind_lh, :);
ind_rh = find(CorticalCon_Sig(:, 1) > 2000);
CorticalCon_Sig_rh = CorticalCon_Sig(ind_rh, :);
% lh
Vertex_AllLabel_InAtlas_lh = Name_lh.table(2:end, 5);
VertexStatistical_lh = zeros(size(VertexLabel_lh));
Sig_ID = CorticalCon_Sig_lh(:, 1);
for i = 1:length(Sig_ID)
  Vertex_LabelID = Vertex_AllLabel_InAtlas_lh(Sig_ID(i) - 1000);
  VertexIndex = find(VertexLabel_lh == Vertex_LabelID);
  VertexStatistical_lh(VertexIndex) = CorticalCon_Sig_lh(i, 2);
end
V_lh = gifti;
V_lh.cdata = VertexStatistical_lh;
V_lh_File = [ProjectFolder '/CortCon_lh.func.gii'];
save(V_lh, V_lh_File);
% rh
Vertex_AllLabel_InAtlas_rh = Name_rh.table(2:end, 5);
VertexStatistical_rh = zeros(size(VertexLabel_rh));
Sig_ID = CorticalCon_Sig_rh(:, 1);
for i = 1:length(Sig_ID)
  Vertex_LabelID = Vertex_AllLabel_InAtlas_rh(Sig_ID(i) - 2000);
  VertexIndex = find(VertexLabel_rh == Vertex_LabelID);
  VertexStatistical_rh(VertexIndex) = CorticalCon_Sig_rh(i, 2);
end
V_rh = gifti;
V_rh.cdata = VertexStatistical_rh;
V_rh_File = [ProjectFolder '/CortCon_rh.func.gii'];
save(V_rh, V_rh_File);

