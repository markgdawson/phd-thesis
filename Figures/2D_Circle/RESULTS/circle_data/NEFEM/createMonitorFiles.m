for iFile=1:nFiles
  uPointFile=[fileInputs{iFile},'_uPoint.1.mat'];
  monPointFile=[fileInputs{iFile},'.1.monitorPoint'];
  uPoint=importdata(uPointFile);
  fid = fopen(monPointFile,'w');
  fprintf(fid,'%d\n2\n',uPoint.nOfComponents);
  fprintf(fid,'%7.5f\n%7.5f\n',uPoint.x);
  fprintf(fid,'-1\n');
  fprintf(fid,'0\n');
  fprintf(fid,'%d\n',uPoint.bufferLen);
  fclose(fid);
  disp(monPointFile);
end
